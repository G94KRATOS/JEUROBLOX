local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))
local remotes = ReplicatedStorage:WaitForChild("AnimeEggRemotes")
local notifyRemote = remotes:WaitForChild("Notify")
local shopRemote = remotes:WaitForChild("ShopAction")
local hatchRemote = remotes:WaitForChild("HatchEffect")
local requestState = remotes:WaitForChild("RequestState")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end)

local old = playerGui:FindFirstChild("AnimeEggUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeEggUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local C = {
	Ink = Color3.fromRGB(38, 41, 48),
	Panel = Color3.fromRGB(249, 250, 252),
	White = Color3.fromRGB(255, 255, 255),
	Green = Color3.fromRGB(72, 216, 74),
	Blue = Color3.fromRGB(67, 174, 255),
	Orange = Color3.fromRGB(255, 165, 54),
	Purple = Color3.fromRGB(174, 86, 255),
	Red = Color3.fromRGB(255, 76, 84),
	Yellow = Color3.fromRGB(255, 220, 66),
	Cyan = Color3.fromRGB(70, 216, 236),
	Muted = Color3.fromRGB(105, 112, 126),
}

local function corner(parent, radius)
	local x = Instance.new("UICorner")
	x.CornerRadius = UDim.new(0, radius)
	x.Parent = parent
	return x
end

local function stroke(parent, color, thickness, transparency)
	local x = Instance.new("UIStroke")
	x.Color = color or C.Ink
	x.Thickness = thickness or 2
	x.Transparency = transparency or 0
	x.Parent = parent
	return x
end

local function gradient(parent, a, b, rotation)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(a, b)
	g.Rotation = rotation or 0
	g.Parent = parent
	return g
end

local function text(parent, value, size, pos, fontSize, color, font, align)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Size = size
	l.Position = pos or UDim2.new()
	l.Text = value
	l.TextSize = fontSize or 16
	l.TextColor3 = color or C.Ink
	l.Font = font or Enum.Font.GothamBold
	l.TextXAlignment = align or Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.Parent = parent
	return l
end

local function makeButton(parent, title, color, size)
	local b = Instance.new("TextButton")
	b.Size = size or UDim2.fromOffset(138, 48)
	b.BackgroundColor3 = color
	b.Text = title
	b.TextColor3 = C.White
	b.TextSize = 17
	b.Font = Enum.Font.GothamBlack
	b.AutoButtonColor = false
	b.Parent = parent
	corner(b, 9)
	stroke(b, Color3.fromRGB(36, 38, 43), 3, 0.18)

	local original = b.Size
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.1), {
			Size = UDim2.new(original.X.Scale, original.X.Offset + 5, original.Y.Scale, original.Y.Offset + 3),
		}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.1), {Size = original}):Play()
	end)
	return b
end

-- Left menu: intentionally simple and bright like simulator/tycoon games.
local leftMenu = Instance.new("Frame")
leftMenu.Position = UDim2.fromOffset(12, 115)
leftMenu.Size = UDim2.fromOffset(150, 180)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = gui

local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 8)
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
leftLayout.Parent = leftMenu

local shopButton = makeButton(leftMenu, "SHOP", C.Green)
local indexButton = makeButton(leftMenu, "INDEX", C.Blue)
local baseButton = makeButton(leftMenu, "MY BASE", C.Orange)

-- Right-side quick buttons.
local rightMenu = Instance.new("Frame")
rightMenu.AnchorPoint = Vector2.new(1, 0)
rightMenu.Position = UDim2.new(1, -12, 0, 115)
rightMenu.Size = UDim2.fromOffset(150, 180)
rightMenu.BackgroundTransparency = 1
rightMenu.Parent = gui

local rightLayout = Instance.new("UIListLayout")
rightLayout.Padding = UDim.new(0, 8)
rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
rightLayout.Parent = rightMenu

local eggsButton = makeButton(rightMenu, "EGGS", C.Yellow)
eggsButton.TextColor3 = C.Ink
local heroesButton = makeButton(rightMenu, "HEROES", C.Purple)
local shieldButton = makeButton(rightMenu, "SHIELD", C.Cyan)
shieldButton.TextColor3 = C.Ink

-- Top mission banner.
local mission = Instance.new("Frame")
mission.AnchorPoint = Vector2.new(0.5, 0)
mission.Position = UDim2.new(0.5, 0, 0, 14)
mission.Size = UDim2.fromOffset(470, 56)
mission.BackgroundColor3 = C.White
mission.BackgroundTransparency = 0.04
mission.Parent = gui
corner(mission, 12)
stroke(mission, Color3.fromRGB(45, 48, 55), 3, 0.16)

local missionAccent = Instance.new("Frame")
missionAccent.Size = UDim2.new(1, -14, 0, 7)
missionAccent.Position = UDim2.new(0, 7, 1, -10)
missionAccent.BackgroundColor3 = C.Green
missionAccent.BorderSizePixel = 0
missionAccent.Parent = mission
corner(missionAccent, 5)
gradient(missionAccent, C.Green, C.Yellow, 0)

local missionText = text(
	mission,
	"STEAL A NINJA EGG!",
	UDim2.new(1, -20, 1, -10),
	UDim2.fromOffset(10, -3),
	20,
	C.Ink,
	Enum.Font.GothamBlack,
	Enum.TextXAlignment.Center
)

-- Bottom-left stats.
local money = text(gui, "$0", UDim2.fromOffset(270, 42), UDim2.new(0, 18, 1, -62), 30, C.Green, Enum.Font.GothamBlack)
money.TextStrokeColor3 = Color3.fromRGB(37, 45, 38)
money.TextStrokeTransparency = 0.55

local income = text(gui, "+$0/s", UDim2.fromOffset(160, 26), UDim2.new(0, 22, 1, -90), 17, C.Yellow, Enum.Font.GothamBlack)
income.TextStrokeTransparency = 0.65

local speed = text(gui, "SPEED 0", UDim2.fromOffset(230, 34), UDim2.new(0, 18, 1, -125), 22, C.Blue, Enum.Font.GothamBlack)
speed.TextStrokeTransparency = 0.65

-- Bottom-right base summary.
local baseSummary = Instance.new("Frame")
baseSummary.AnchorPoint = Vector2.new(1, 1)
baseSummary.Position = UDim2.new(1, -16, 1, -18)
baseSummary.Size = UDim2.fromOffset(215, 80)
baseSummary.BackgroundColor3 = C.White
baseSummary.BackgroundTransparency = 0.05
baseSummary.Parent = gui
corner(baseSummary, 11)
stroke(baseSummary, C.Ink, 2, 0.55)

local heroesCount = text(baseSummary, "HEROES 0/12", UDim2.new(1, -16, 0, 30), UDim2.fromOffset(8, 8), 15, C.Purple, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
local baseLevelText = text(baseSummary, "BASE LV.1", UDim2.new(1, -16, 0, 26), UDim2.fromOffset(8, 38), 14, C.Orange, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)

-- Carry card.
local carryCard = Instance.new("Frame")
carryCard.AnchorPoint = Vector2.new(0.5, 1)
carryCard.Position = UDim2.new(0.5, 0, 1, -18)
carryCard.Size = UDim2.fromOffset(410, 72)
carryCard.BackgroundColor3 = C.White
carryCard.Visible = false
carryCard.Parent = gui
corner(carryCard, 12)
local carryStroke = stroke(carryCard, C.Purple, 3, 0.05)

local carryName = text(carryCard, "", UDim2.new(1, -20, 0, 32), UDim2.fromOffset(10, 7), 18, C.Purple, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
local carryHint = text(carryCard, "RUN BACK TO YOUR BASE!", UDim2.new(1, -20, 0, 24), UDim2.fromOffset(10, 40), 13, C.Green, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)

-- Toast notifications.
local toastHolder = Instance.new("Frame")
toastHolder.AnchorPoint = Vector2.new(0.5, 0)
toastHolder.Position = UDim2.new(0.5, 0, 0, 78)
toastHolder.Size = UDim2.fromOffset(440, 165)
toastHolder.BackgroundTransparency = 1
toastHolder.Parent = gui

local toastLayout = Instance.new("UIListLayout")
toastLayout.Padding = UDim.new(0, 7)
toastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
toastLayout.Parent = toastHolder

local function showToast(message, kind)
	local color = C.Blue
	if kind == "Success" then color = C.Green end
	if kind == "Error" or kind == "Danger" then color = C.Red end

	local box = Instance.new("TextLabel")
	box.Size = UDim2.fromOffset(400, 42)
	box.BackgroundColor3 = C.White
	box.BackgroundTransparency = 0.02
	box.Text = tostring(message)
	box.TextColor3 = C.Ink
	box.TextSize = 14
	box.Font = Enum.Font.GothamBold
	box.Parent = toastHolder
	corner(box, 9)
	stroke(box, color, 3, 0.05)

	box.TextTransparency = 1
	box.BackgroundTransparency = 1
	TweenService:Create(box, TweenInfo.new(0.14), {TextTransparency = 0, BackgroundTransparency = 0.02}):Play()

	task.delay(3.1, function()
		if not box.Parent then return end
		local t = TweenService:Create(box, TweenInfo.new(0.16), {TextTransparency = 1, BackgroundTransparency = 1})
		t:Play()
		t.Completed:Wait()
		box:Destroy()
	end)
end

-- Modal system.
local shade = Instance.new("Frame")
shade.Size = UDim2.fromScale(1, 1)
shade.BackgroundColor3 = Color3.new(0, 0, 0)
shade.BackgroundTransparency = 0.45
shade.Visible = false
shade.ZIndex = 40
shade.Parent = gui

local openModal

local function createModal(titleValue, width, height)
	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.Size = UDim2.fromOffset(width, height)
	frame.BackgroundColor3 = C.Panel
	frame.Visible = false
	frame.ZIndex = 50
	frame.Parent = gui
	corner(frame, 15)
	stroke(frame, C.Ink, 3, 0.1)

	local title = text(frame, titleValue, UDim2.new(1, -80, 0, 46), UDim2.fromOffset(20, 12), 22, C.Ink, Enum.Font.GothamBlack)
	title.ZIndex = 51

	local close = makeButton(frame, "X", C.Red, UDim2.fromOffset(42, 40))
	close.Position = UDim2.new(1, -55, 0, 12)
	close.ZIndex = 52
	close.MouseButton1Click:Connect(function()
		frame.Visible = false
		shade.Visible = false
	end)

	return frame
end

local shopModal = createModal("UPGRADES", 560, 350)
local indexModal = createModal("HERO INDEX", 620, 430)
local eggsModal = createModal("NINJA EGGS", 600, 410)

local function upgradeCard(parent, y, titleValue, description, color)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, -40, 0, 105)
	card.Position = UDim2.fromOffset(20, y)
	card.BackgroundColor3 = Color3.fromRGB(232, 236, 243)
	card.ZIndex = 51
	card.Parent = parent
	corner(card, 11)
	stroke(card, color, 2, 0.22)

	local title = text(card, titleValue, UDim2.fromOffset(200, 28), UDim2.fromOffset(15, 10), 17, color, Enum.Font.GothamBlack)
	title.ZIndex = 52

	local desc = text(card, description, UDim2.fromOffset(285, 23), UDim2.fromOffset(15, 42), 12, C.Muted, Enum.Font.GothamMedium)
	desc.ZIndex = 52

	local level = text(card, "LV.1", UDim2.fromOffset(120, 23), UDim2.fromOffset(15, 70), 13, C.Ink, Enum.Font.GothamBold)
	level.ZIndex = 52

	local buy = makeButton(card, "$?", color, UDim2.fromOffset(150, 54))
	buy.Position = UDim2.new(1, -166, 0.5, -27)
	buy.ZIndex = 52

	return level, buy
end

local baseLevelLabel, buyBase = upgradeCard(shopModal, 76, "BASE INCOME", "+25% cash per base level", C.Green)
local trainingLevelLabel, buyTraining = upgradeCard(shopModal, 198, "SPEED TREADMILL", "Gain more Speed every tick", C.Blue)

-- Hero index grid.
local indexInfo = text(indexModal, "Collect heroes by stealing Ninja Eggs.", UDim2.new(1, -40, 0, 28), UDim2.fromOffset(20, 60), 13, C.Muted, Enum.Font.GothamMedium)
indexInfo.ZIndex = 51

local indexGrid = Instance.new("Frame")
indexGrid.Size = UDim2.new(1, -40, 1, -110)
indexGrid.Position = UDim2.fromOffset(20, 95)
indexGrid.BackgroundTransparency = 1
indexGrid.ZIndex = 51
indexGrid.Parent = indexModal

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.fromOffset(135, 70)
gridLayout.CellPadding = UDim2.fromOffset(8, 8)
gridLayout.Parent = indexGrid

-- Egg odds list.
local oddsContainer = Instance.new("Frame")
oddsContainer.Size = UDim2.new(1, -40, 1, -100)
oddsContainer.Position = UDim2.fromOffset(20, 82)
oddsContainer.BackgroundTransparency = 1
oddsContainer.ZIndex = 51
oddsContainer.Parent = eggsModal

local oddsLayout = Instance.new("UIListLayout")
oddsLayout.Padding = UDim.new(0, 5)
oddsLayout.Parent = oddsContainer

local function rarityWeightTotals()
	local totals = {}
	local full = 0
	for _, hero in ipairs(Config.NarutoWorld.Heroes) do
		totals[hero.Rarity] = (totals[hero.Rarity] or 0) + hero.Weight
		full += hero.Weight
	end
	return totals, full
end

local totals, totalWeight = rarityWeightTotals()
for _, rarityName in ipairs({"Common", "Rare", "Epic", "Legendary", "Mythic", "Secret"}) do
	local data = Config.Rarities[rarityName]
	local chance = ((totals[rarityName] or 0) / totalWeight) * 100
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 42)
	row.BackgroundColor3 = Color3.fromRGB(233, 236, 242)
	row.ZIndex = 52
	row.Parent = oddsContainer
	corner(row, 8)

	local name = text(row, rarityName, UDim2.fromOffset(160, 42), UDim2.fromOffset(12, 0), 14, data.Color, Enum.Font.GothamBlack)
	name.ZIndex = 53

	local chanceText = text(row, string.format("%.2f%%", chance), UDim2.fromOffset(100, 42), UDim2.new(1, -112, 0, 0), 14, C.Ink, Enum.Font.GothamBlack, Enum.TextXAlignment.Right)
	chanceText.ZIndex = 53
end

local function currentState()
	local ok, result = pcall(function()
		return requestState:InvokeServer()
	end)
	if ok and result then return result end
	return {}
end

local function refreshShop()
	local state = currentState()
	baseLevelLabel.Text = "LV." .. tostring(state.BaseLevel or player:GetAttribute("BaseLevel") or 1)
	trainingLevelLabel.Text = "LV." .. tostring(state.TrainingLevel or player:GetAttribute("TrainingLevel") or 1)
	buyBase.Text = "$" .. tostring(state.BaseUpgradeCost or "?")
	buyTraining.Text = "$" .. tostring(state.TrainingUpgradeCost or "?")
end

local function refreshIndex()
	for _, child in ipairs(indexGrid:GetChildren()) do
		if not child:IsA("UIGridLayout") then child:Destroy() end
	end

	local state = currentState()
	local owned = {}
	for _, hero in ipairs(state.Heroes or {}) do
		owned[hero.Name] = (owned[hero.Name] or 0) + 1
	end

	for _, hero in ipairs(Config.NarutoWorld.Heroes) do
		local data = Config.Rarities[hero.Rarity]
		local card = Instance.new("Frame")
		card.BackgroundColor3 = owned[hero.Name] and Color3.fromRGB(238, 241, 246) or Color3.fromRGB(213, 217, 224)
		card.ZIndex = 52
		card.Parent = indexGrid
		corner(card, 9)
		stroke(card, data.Color, 2, owned[hero.Name] and 0.1 or 0.55)

		local heroName = text(
			card,
			owned[hero.Name] and hero.Name or "???",
			UDim2.new(1, -12, 0, 28),
			UDim2.fromOffset(6, 6),
			12,
			owned[hero.Name] and C.Ink or C.Muted,
			Enum.Font.GothamBlack,
			Enum.TextXAlignment.Center
		)
		heroName.ZIndex = 53

		local rarity = text(
			card,
			hero.Rarity .. (owned[hero.Name] and (" x" .. tostring(owned[hero.Name])) or ""),
			UDim2.new(1, -12, 0, 24),
			UDim2.fromOffset(6, 36),
			10,
			data.Color,
			Enum.Font.GothamBold,
			Enum.TextXAlignment.Center
		)
		rarity.ZIndex = 53
	end
end

local function showModal(frame)
	shade.Visible = true
	shopModal.Visible = false
	indexModal.Visible = false
	eggsModal.Visible = false
	frame.Visible = true
end

shopButton.MouseButton1Click:Connect(function()
	refreshShop()
	showModal(shopModal)
end)

indexButton.MouseButton1Click:Connect(function()
	refreshIndex()
	showModal(indexModal)
end)

heroesButton.MouseButton1Click:Connect(function()
	refreshIndex()
	showModal(indexModal)
end)

eggsButton.MouseButton1Click:Connect(function()
	showModal(eggsModal)
end)

baseButton.MouseButton1Click:Connect(function()
	local baseIndex = player:GetAttribute("BaseIndex")
	if baseIndex and baseIndex > 0 then
		showToast("YOUR BASE: " .. tostring(baseIndex), "Success")
	else
		showToast("No base assigned.", "Error")
	end
end)

shieldButton.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Shield")
end)

buyBase.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Base")
	task.delay(0.25, refreshShop)
end)

buyTraining.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Training")
	task.delay(0.25, refreshShop)
end)

-- Hatch reveal.
local hatchOverlay = Instance.new("Frame")
hatchOverlay.Size = UDim2.fromScale(1, 1)
hatchOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
hatchOverlay.BackgroundTransparency = 1
hatchOverlay.Visible = false
hatchOverlay.ZIndex = 80
hatchOverlay.Parent = gui

local hatchCard = Instance.new("Frame")
hatchCard.AnchorPoint = Vector2.new(0.5, 0.5)
hatchCard.Position = UDim2.fromScale(0.5, 0.5)
hatchCard.Size = UDim2.fromOffset(430, 245)
hatchCard.BackgroundColor3 = C.White
hatchCard.ZIndex = 81
hatchCard.Parent = hatchOverlay
corner(hatchCard, 18)
local hatchStroke = stroke(hatchCard, C.Purple, 5, 0.02)

local hatchTitle = text(hatchCard, "NEW HERO!", UDim2.new(1, -30, 0, 45), UDim2.fromOffset(15, 22), 25, C.Ink, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
hatchTitle.ZIndex = 82
local hatchName = text(hatchCard, "", UDim2.new(1, -30, 0, 65), UDim2.fromOffset(15, 86), 32, C.Purple, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
hatchName.ZIndex = 82
local hatchRarity = text(hatchCard, "", UDim2.new(1, -30, 0, 38), UDim2.fromOffset(15, 155), 18, C.Purple, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
hatchRarity.ZIndex = 82
local hatchHint = text(hatchCard, "Now earning cash at your base!", UDim2.new(1, -30, 0, 26), UDim2.fromOffset(15, 198), 13, C.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
hatchHint.ZIndex = 82

local function playHatch(name, rarityName, rarityColor)
	hatchOverlay.Visible = true
	hatchOverlay.BackgroundTransparency = 1
	hatchCard.Size = UDim2.fromOffset(250, 150)
	hatchCard.BackgroundTransparency = 1
	hatchName.TextTransparency = 1
	hatchRarity.TextTransparency = 1
	hatchTitle.TextTransparency = 1

	hatchName.Text = tostring(name)
	hatchRarity.Text = tostring(rarityName)
	hatchName.TextColor3 = rarityColor or C.Purple
	hatchRarity.TextColor3 = rarityColor or C.Purple
	hatchStroke.Color = rarityColor or C.Purple

	TweenService:Create(hatchOverlay, TweenInfo.new(0.16), {BackgroundTransparency = 0.45}):Play()
	TweenService:Create(hatchCard, TweenInfo.new(0.24, Enum.EasingStyle.Back), {
		Size = UDim2.fromOffset(430, 245),
		BackgroundTransparency = 0,
	}):Play()

	task.wait(0.12)
	TweenService:Create(hatchName, TweenInfo.new(0.18), {TextTransparency = 0}):Play()
	TweenService:Create(hatchRarity, TweenInfo.new(0.18), {TextTransparency = 0}):Play()
	TweenService:Create(hatchTitle, TweenInfo.new(0.18), {TextTransparency = 0}):Play()

	task.delay(2.3, function()
		local fade = TweenService:Create(hatchOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1})
		fade:Play()
		TweenService:Create(hatchCard, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		fade.Completed:Wait()
		hatchOverlay.Visible = false
	end)
end

local leaderstats = player:WaitForChild("leaderstats")
local coins = leaderstats:WaitForChild("Coins")
local speedStat = leaderstats:WaitForChild("Speed")

local function refreshHUD()
	local incomeValue = player:GetAttribute("IncomePerSecond") or 0
	local count = player:GetAttribute("HeroCount") or 0
	local baseLevel = player:GetAttribute("BaseLevel") or 1
	local carrying = player:GetAttribute("CarryingName")
	local carryingRarity = player:GetAttribute("CarryingRarity")

	money.Text = "$" .. tostring(coins.Value)
	income.Text = "+$" .. tostring(incomeValue) .. "/s"
	speed.Text = "SPEED " .. tostring(speedStat.Value)
	heroesCount.Text = "HEROES " .. tostring(count) .. "/" .. tostring(Config.MaxHeroes)
	baseLevelText.Text = "BASE LV." .. tostring(baseLevel)

	if player:GetAttribute("ShieldActive") then
		shieldButton.Text = "SHIELD ON"
		shieldButton.BackgroundColor3 = C.Green
	else
		shieldButton.Text = "SHIELD"
		shieldButton.BackgroundColor3 = C.Cyan
	end

	if carrying and carrying ~= "" then
		carryCard.Visible = true
		carryName.Text = carrying .. "  [" .. tostring(carryingRarity) .. "]"
		local rarityInfo = Config.Rarities[carryingRarity]
		if rarityInfo then
			carryName.TextColor3 = rarityInfo.Color
			carryStroke.Color = rarityInfo.Color
		end
		missionText.Text = "RUN BACK TO YOUR BASE!"
		missionAccent.BackgroundColor3 = C.Orange
	else
		carryCard.Visible = false
		missionText.Text = "STEAL A NINJA EGG!"
		missionAccent.BackgroundColor3 = C.Green
	end
end

coins.Changed:Connect(refreshHUD)
speedStat.Changed:Connect(refreshHUD)

for _, attribute in ipairs({
	"IncomePerSecond",
	"HeroCount",
	"BaseLevel",
	"TrainingLevel",
	"CarryingName",
	"CarryingRarity",
	"BaseIndex",
	"ShieldActive",
}) do
	player:GetAttributeChangedSignal(attribute):Connect(refreshHUD)
end

notifyRemote.OnClientEvent:Connect(function(message, kind)
	showToast(message, kind)
	refreshHUD()
end)

hatchRemote.OnClientEvent:Connect(function(name, rarityName, rarityColor)
	playHatch(name, rarityName, rarityColor)
	refreshHUD()
	refreshIndex()
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.B then
		refreshShop()
		showModal(shopModal)
	elseif input.KeyCode == Enum.KeyCode.I then
		refreshIndex()
		showModal(indexModal)
	end
end)

refreshHUD()
task.delay(1.3, function()
	showToast("Cross the village gate, steal a Ninja Egg, then bring it home.", "Success")
end)
