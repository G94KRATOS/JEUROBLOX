local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))
local remotes = ReplicatedStorage:WaitForChild("AnimeEggRemotes")
local notifyRemote = remotes:WaitForChild("Notify")
local shopRemote = remotes:WaitForChild("ShopAction")
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

local COLORS = {
	Panel = Color3.fromRGB(16, 18, 28),
	Panel2 = Color3.fromRGB(24, 27, 40),
	Purple = Color3.fromRGB(154, 95, 255),
	Pink = Color3.fromRGB(255, 91, 187),
	Cyan = Color3.fromRGB(77, 215, 255),
	Gold = Color3.fromRGB(255, 211, 78),
	Green = Color3.fromRGB(81, 230, 143),
	Red = Color3.fromRGB(255, 91, 105),
	Text = Color3.fromRGB(245, 247, 255),
	Muted = Color3.fromRGB(163, 172, 195),
}

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function stroke(parent, color, transparency, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or COLORS.Purple
	s.Transparency = transparency or 0.35
	s.Thickness = thickness or 1.4
	s.Parent = parent
	return s
end

local function gradient(parent, c1, c2, rotation)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(c1, c2)
	g.Rotation = rotation or 0
	g.Parent = parent
	return g
end

local function padding(parent, left, right, top, bottom)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, left or 0)
	p.PaddingRight = UDim.new(0, right or 0)
	p.PaddingTop = UDim.new(0, top or 0)
	p.PaddingBottom = UDim.new(0, bottom or 0)
	p.Parent = parent
	return p
end

local function label(parent, text, size, pos, textSize, font, color, align)
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Size = size
	t.Position = pos or UDim2.new()
	t.Text = text
	t.TextColor3 = color or COLORS.Text
	t.TextSize = textSize or 16
	t.Font = font or Enum.Font.GothamBold
	t.TextXAlignment = align or Enum.TextXAlignment.Left
	t.TextYAlignment = Enum.TextYAlignment.Center
	t.Parent = parent
	return t
end

local function button(parent, text, size, color1, color2)
	local b = Instance.new("TextButton")
	b.Size = size
	b.BackgroundColor3 = color1 or COLORS.Panel2
	b.Text = text
	b.TextColor3 = COLORS.Text
	b.TextSize = 15
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = parent
	corner(b, 13)
	stroke(b, color2 or COLORS.Purple, 0.45, 1.2)
	if color2 then
		gradient(b, color1, color2, 0)
	end

	local baseSize = b.Size
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {Size = UDim2.new(baseSize.X.Scale, baseSize.X.Offset + 5, baseSize.Y.Scale, baseSize.Y.Offset + 3)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {Size = baseSize}):Play()
	end)
	return b
end

local vignette = Instance.new("Frame")
vignette.Size = UDim2.fromScale(1, 1)
vignette.BackgroundColor3 = Color3.new(0, 0, 0)
vignette.BackgroundTransparency = 0.94
vignette.BorderSizePixel = 0
vignette.ZIndex = 0
vignette.Parent = gui

local top = Instance.new("Frame")
top.AnchorPoint = Vector2.new(0.5, 0)
top.Position = UDim2.new(0.5, 0, 0, 18)
top.Size = UDim2.new(0, 730, 0, 72)
top.BackgroundColor3 = COLORS.Panel
top.BackgroundTransparency = 0.05
top.ZIndex = 10
top.Parent = gui
corner(top, 20)
stroke(top, COLORS.Purple, 0.25, 1.5)

local topGlow = Instance.new("Frame")
topGlow.Size = UDim2.new(1, -18, 0, 3)
topGlow.Position = UDim2.new(0, 9, 1, -5)
topGlow.BackgroundColor3 = COLORS.Purple
topGlow.BorderSizePixel = 0
topGlow.ZIndex = 11
topGlow.Parent = top
corner(topGlow, 4)
gradient(topGlow, COLORS.Pink, COLORS.Cyan, 0)

label(top, "ANIME EGG", UDim2.fromOffset(118, 24), UDim2.fromOffset(22, 12), 17, Enum.Font.GothamBlack, COLORS.Text)
label(top, "HEIST", UDim2.fromOffset(90, 24), UDim2.fromOffset(22, 36), 18, Enum.Font.GothamBlack, COLORS.Purple)

local separator1 = Instance.new("Frame")
separator1.Size = UDim2.fromOffset(1, 42)
separator1.Position = UDim2.fromOffset(154, 14)
separator1.BackgroundColor3 = Color3.fromRGB(66, 70, 90)
separator1.BorderSizePixel = 0
separator1.Parent = top

local coinsLabel = label(top, "$ 0", UDim2.fromOffset(155, 42), UDim2.fromOffset(175, 15), 22, Enum.Font.GothamBlack, COLORS.Gold)
local incomeLabel = label(top, "+$0/s", UDim2.fromOffset(90, 22), UDim2.fromOffset(248, 42), 12, Enum.Font.GothamMedium, COLORS.Green)

local speedLabel = label(top, "SPEED 0", UDim2.fromOffset(145, 42), UDim2.fromOffset(355, 15), 19, Enum.Font.GothamBlack, COLORS.Cyan)
local heroLabel = label(top, "HEROES 0/12", UDim2.fromOffset(160, 42), UDim2.fromOffset(535, 15), 17, Enum.Font.GothamBlack, COLORS.Pink)

local left = Instance.new("Frame")
left.AnchorPoint = Vector2.new(0, 0.5)
left.Position = UDim2.new(0, 18, 0.5, 0)
left.Size = UDim2.fromOffset(176, 260)
left.BackgroundTransparency = 1
left.Parent = gui

local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 10)
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
leftLayout.Parent = left

local shopButton = button(left, "  BOUTIQUE", UDim2.fromOffset(170, 58), Color3.fromRGB(53, 38, 85), Color3.fromRGB(101, 62, 168))
shopButton.TextXAlignment = Enum.TextXAlignment.Left
padding(shopButton, 20)

local invButton = button(left, "  INVENTAIRE", UDim2.fromOffset(170, 58), Color3.fromRGB(35, 51, 78), Color3.fromRGB(46, 117, 162))
invButton.TextXAlignment = Enum.TextXAlignment.Left
padding(invButton, 20)

local baseButton = button(left, "  MA BASE", UDim2.fromOffset(170, 58), Color3.fromRGB(61, 44, 62), Color3.fromRGB(129, 65, 107))
baseButton.TextXAlignment = Enum.TextXAlignment.Left
padding(baseButton, 20)

local helpButton = button(left, "  COMMENT JOUER", UDim2.fromOffset(170, 58), Color3.fromRGB(45, 48, 60), Color3.fromRGB(79, 84, 101))
helpButton.TextXAlignment = Enum.TextXAlignment.Left
padding(helpButton, 20)

local quest = Instance.new("Frame")
quest.AnchorPoint = Vector2.new(1, 0.5)
quest.Position = UDim2.new(1, -20, 0.52, 0)
quest.Size = UDim2.fromOffset(250, 170)
quest.BackgroundColor3 = COLORS.Panel
quest.BackgroundTransparency = 0.06
quest.Parent = gui
corner(quest, 18)
stroke(quest, COLORS.Cyan, 0.55)

label(quest, "PROGRESSION", UDim2.new(1, -30, 0, 28), UDim2.fromOffset(16, 14), 14, Enum.Font.GothamBlack, COLORS.Cyan)

local nextZoneLabel = label(quest, "Blossom Village", UDim2.new(1, -30, 0, 28), UDim2.fromOffset(16, 47), 16, Enum.Font.GothamBold, COLORS.Text)
local reqLabel = label(quest, "0 Speed requis", UDim2.new(1, -30, 0, 20), UDim2.fromOffset(16, 75), 12, Enum.Font.GothamMedium, COLORS.Muted)

local progressBack = Instance.new("Frame")
progressBack.Size = UDim2.new(1, -32, 0, 12)
progressBack.Position = UDim2.fromOffset(16, 104)
progressBack.BackgroundColor3 = Color3.fromRGB(37, 41, 56)
progressBack.BorderSizePixel = 0
progressBack.Parent = quest
corner(progressBack, 8)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = COLORS.Cyan
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBack
corner(progressFill, 8)
gradient(progressFill, COLORS.Purple, COLORS.Cyan, 0)

local hintLabel = label(quest, "Entraîne-toi sur ton tapis.", UDim2.new(1, -30, 0, 30), UDim2.fromOffset(16, 125), 12, Enum.Font.GothamMedium, COLORS.Muted)

local carryCard = Instance.new("Frame")
carryCard.AnchorPoint = Vector2.new(0.5, 1)
carryCard.Position = UDim2.new(0.5, 0, 1, -22)
carryCard.Size = UDim2.fromOffset(450, 74)
carryCard.BackgroundColor3 = COLORS.Panel
carryCard.BackgroundTransparency = 0.03
carryCard.Visible = false
carryCard.Parent = gui
corner(carryCard, 18)
local carryStroke = stroke(carryCard, COLORS.Purple, 0.2, 1.6)

local carryTitle = label(carryCard, "TU TRANSPORTES", UDim2.fromOffset(150, 24), UDim2.fromOffset(18, 12), 12, Enum.Font.GothamBlack, COLORS.Muted)
local carryName = label(carryCard, "", UDim2.fromOffset(250, 30), UDim2.fromOffset(18, 34), 18, Enum.Font.GothamBlack, COLORS.Text)
local carryHint = label(carryCard, "RAMÈNE-LE À TA BASE", UDim2.fromOffset(190, 50), UDim2.fromOffset(245, 12), 12, Enum.Font.GothamBlack, COLORS.Green, Enum.TextXAlignment.Right)

local toastHolder = Instance.new("Frame")
toastHolder.AnchorPoint = Vector2.new(0.5, 0)
toastHolder.Position = UDim2.new(0.5, 0, 0, 102)
toastHolder.Size = UDim2.fromOffset(420, 150)
toastHolder.BackgroundTransparency = 1
toastHolder.Parent = gui

local toastLayout = Instance.new("UIListLayout")
toastLayout.Padding = UDim.new(0, 8)
toastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
toastLayout.Parent = toastHolder

local function showToast(message, kind)
	local colors = {
		Success = COLORS.Green,
		Error = COLORS.Red,
		Danger = COLORS.Red,
		Info = COLORS.Purple,
	}
	local color = colors[kind] or COLORS.Purple

	local box = Instance.new("TextLabel")
	box.Size = UDim2.fromOffset(380, 44)
	box.BackgroundColor3 = COLORS.Panel
	box.BackgroundTransparency = 1
	box.Text = message
	box.TextColor3 = COLORS.Text
	box.TextTransparency = 1
	box.TextSize = 13
	box.Font = Enum.Font.GothamBold
	box.Parent = toastHolder
	corner(box, 12)
	stroke(box, color, 0.3, 1.3)

	TweenService:Create(box, TweenInfo.new(0.18), {
		BackgroundTransparency = 0.04,
		TextTransparency = 0,
	}):Play()

	task.delay(3.2, function()
		if not box.Parent then return end
		local tween = TweenService:Create(box, TweenInfo.new(0.18), {
			BackgroundTransparency = 1,
			TextTransparency = 1,
		})
		tween:Play()
		tween.Completed:Wait()
		box:Destroy()
	end)
end

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.new(0, 0, 0)
overlay.BackgroundTransparency = 0.38
overlay.Visible = false
overlay.ZIndex = 40
overlay.Parent = gui

local function makeModal(titleText, width, height)
	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.Size = UDim2.fromOffset(width, height)
	frame.BackgroundColor3 = COLORS.Panel
	frame.Visible = false
	frame.ZIndex = 50
	frame.Parent = gui
	corner(frame, 22)
	stroke(frame, COLORS.Purple, 0.2, 1.5)

	local title = label(frame, titleText, UDim2.new(1, -85, 0, 42), UDim2.fromOffset(24, 18), 22, Enum.Font.GothamBlack, COLORS.Text)
	title.ZIndex = 51

	local close = button(frame, "X", UDim2.fromOffset(42, 42), Color3.fromRGB(67, 38, 50), Color3.fromRGB(128, 54, 72))
	close.Position = UDim2.new(1, -60, 0, 16)
	close.ZIndex = 52
	close.MouseButton1Click:Connect(function()
		frame.Visible = false
		overlay.Visible = false
	end)

	return frame
end

local shopModal = makeModal("BOUTIQUE D'AMÉLIORATIONS", 560, 390)

local shopSubtitle = label(shopModal, "Améliore ton économie et ta vitesse.", UDim2.new(1, -48, 0, 25), UDim2.fromOffset(24, 62), 13, Enum.Font.GothamMedium, COLORS.Muted)
shopSubtitle.ZIndex = 51

local baseCard = Instance.new("Frame")
baseCard.Size = UDim2.new(1, -48, 0, 120)
baseCard.Position = UDim2.fromOffset(24, 100)
baseCard.BackgroundColor3 = COLORS.Panel2
baseCard.ZIndex = 51
baseCard.Parent = shopModal
corner(baseCard, 16)
stroke(baseCard, COLORS.Pink, 0.5)
local baseTitle = label(baseCard, "BASE", UDim2.fromOffset(110, 28), UDim2.fromOffset(18, 14), 17, Enum.Font.GothamBlack, COLORS.Pink)
baseTitle.ZIndex = 52
local baseDesc = label(baseCard, "+25% revenus par niveau", UDim2.fromOffset(240, 24), UDim2.fromOffset(18, 48), 13, Enum.Font.GothamMedium, COLORS.Muted)
baseDesc.ZIndex = 52
local baseLevelLabel = label(baseCard, "Niveau 1", UDim2.fromOffset(150, 24), UDim2.fromOffset(18, 77), 13, Enum.Font.GothamBold, COLORS.Text)
baseLevelLabel.ZIndex = 52
local buyBase = button(baseCard, "$600", UDim2.fromOffset(155, 54), Color3.fromRGB(91, 51, 88), Color3.fromRGB(174, 79, 150))
buyBase.Position = UDim2.new(1, -173, 0.5, -27)
buyBase.ZIndex = 52

local trainCard = Instance.new("Frame")
trainCard.Size = UDim2.new(1, -48, 0, 120)
trainCard.Position = UDim2.fromOffset(24, 238)
trainCard.BackgroundColor3 = COLORS.Panel2
trainCard.ZIndex = 51
trainCard.Parent = shopModal
corner(trainCard, 16)
stroke(trainCard, COLORS.Cyan, 0.5)
local trainTitle = label(trainCard, "TAPIS SPEED", UDim2.fromOffset(160, 28), UDim2.fromOffset(18, 14), 17, Enum.Font.GothamBlack, COLORS.Cyan)
trainTitle.ZIndex = 52
local trainDesc = label(trainCard, "Gagne plus de Speed à chaque tick", UDim2.fromOffset(270, 24), UDim2.fromOffset(18, 48), 13, Enum.Font.GothamMedium, COLORS.Muted)
trainDesc.ZIndex = 52
local trainLevelLabel = label(trainCard, "Niveau 1", UDim2.fromOffset(150, 24), UDim2.fromOffset(18, 77), 13, Enum.Font.GothamBold, COLORS.Text)
trainLevelLabel.ZIndex = 52
local buyTrain = button(trainCard, "$450", UDim2.fromOffset(155, 54), Color3.fromRGB(31, 82, 98), Color3.fromRGB(47, 145, 172))
buyTrain.Position = UDim2.new(1, -173, 0.5, -27)
buyTrain.ZIndex = 52

local invModal = makeModal("INVENTAIRE", 520, 340)
local invPetCount = label(invModal, "0 / 12 héros", UDim2.new(1, -48, 0, 34), UDim2.fromOffset(24, 78), 20, Enum.Font.GothamBlack, COLORS.Pink)
invPetCount.ZIndex = 51
local invIncome = label(invModal, "$0 / seconde", UDim2.new(1, -48, 0, 34), UDim2.fromOffset(24, 116), 18, Enum.Font.GothamBold, COLORS.Green)
invIncome.ZIndex = 51
local invInfo = label(invModal, "Les héros gagnent de l'argent automatiquement.\nLes autres joueurs peuvent les voler si tu ne surveilles pas ta base.", UDim2.new(1, -48, 0, 80), UDim2.fromOffset(24, 162), 14, Enum.Font.GothamMedium, COLORS.Muted)
invInfo.TextWrapped = true
invInfo.TextYAlignment = Enum.TextYAlignment.Top
invInfo.ZIndex = 51

local rarityText = label(invModal, "COMMON   RARE   EPIC   LEGENDARY   MYTHIC   SECRET", UDim2.new(1, -48, 0, 34), UDim2.fromOffset(24, 260), 11, Enum.Font.GothamBlack, COLORS.Text, Enum.TextXAlignment.Center)
rarityText.ZIndex = 51

local helpModal = makeModal("COMMENT JOUER", 580, 410)
local instructions = {
	"1. Va dans BLOSSOM VILLAGE et vole un oeuf.",
	"2. Ramène l'oeuf dans la zone lumineuse de TA BASE.",
	"3. Il devient un héros qui te rapporte de l'argent chaque seconde.",
	"4. Marche sur ton TAPIS SPEED pour devenir plus rapide.",
	"5. Débloque les zones rares grâce à ta Speed.",
	"6. Tu peux voler les héros des autres joueurs et t'enfuir avec.",
	"7. Améliore ta base et ton tapis pour progresser plus vite.",
}
for i, text in ipairs(instructions) do
	local l = label(helpModal, text, UDim2.new(1, -48, 0, 36), UDim2.fromOffset(24, 70 + (i - 1) * 43), 14, Enum.Font.GothamMedium, i == 6 and COLORS.Pink or COLORS.Text)
	l.TextWrapped = true
	l.ZIndex = 51
end

local function openModal(modal)
	overlay.Visible = true
	shopModal.Visible = false
	invModal.Visible = false
	helpModal.Visible = false
	modal.Visible = true
end

local function refreshShop()
	local ok, state = pcall(function()
		return requestState:InvokeServer()
	end)
	if not ok or not state then return end
	baseLevelLabel.Text = "Niveau " .. tostring(player:GetAttribute("BaseLevel") or 1)
	trainLevelLabel.Text = "Niveau " .. tostring(player:GetAttribute("TrainingLevel") or 1)
	buyBase.Text = "$" .. tostring(state.BaseUpgradeCost or "?")
	buyTrain.Text = "$" .. tostring(state.TrainingUpgradeCost or "?")
end

shopButton.MouseButton1Click:Connect(function()
	refreshShop()
	openModal(shopModal)
end)

invButton.MouseButton1Click:Connect(function()
	openModal(invModal)
end)

helpButton.MouseButton1Click:Connect(function()
	openModal(helpModal)
end)

baseButton.MouseButton1Click:Connect(function()
	local baseIndex = player:GetAttribute("BaseIndex")
	if baseIndex then
		showToast("Ta base est la BASE " .. tostring(baseIndex) .. ".", "Info")
	else
		showToast("Aucune base assignée.", "Error")
	end
end)

buyBase.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Base")
	task.delay(0.25, refreshShop)
end)

buyTrain.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Training")
	task.delay(0.25, refreshShop)
end)

overlay.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		overlay.Visible = false
		shopModal.Visible = false
		invModal.Visible = false
		helpModal.Visible = false
	end
end)

local stats = player:WaitForChild("leaderstats")
local coins = stats:WaitForChild("Coins")
local speed = stats:WaitForChild("Speed")

local function getNextZone(speedValue)
	local previousReq = 0
	for _, zone in ipairs(Config.Zones) do
		if speedValue < zone.RequiredSpeed then
			return zone, previousReq
		end
		previousReq = zone.RequiredSpeed
	end
	return nil, previousReq
end

local function refreshUI()
	local income = player:GetAttribute("IncomePerSecond") or 0
	local pets = player:GetAttribute("PetCount") or 0
	local baseLevel = player:GetAttribute("BaseLevel") or 1
	local trainLevel = player:GetAttribute("TrainingLevel") or 1

	coinsLabel.Text = "$ " .. tostring(coins.Value)
	incomeLabel.Text = "+$" .. tostring(income) .. "/s"
	speedLabel.Text = "SPEED " .. tostring(speed.Value)
	heroLabel.Text = "HEROES " .. tostring(pets) .. "/" .. tostring(Config.MaxPets)

	invPetCount.Text = tostring(pets) .. " / " .. tostring(Config.MaxPets) .. " héros"
	invIncome.Text = "$" .. tostring(income) .. " / seconde"
	baseLevelLabel.Text = "Niveau " .. tostring(baseLevel)
	trainLevelLabel.Text = "Niveau " .. tostring(trainLevel)

	local zone, previousReq = getNextZone(speed.Value)
	if zone then
		nextZoneLabel.Text = zone.Name
		reqLabel.Text = tostring(zone.RequiredSpeed) .. " Speed requis"
		local span = math.max(1, zone.RequiredSpeed - previousReq)
		local pct = math.clamp((speed.Value - previousReq) / span, 0, 1)
		TweenService:Create(progressFill, TweenInfo.new(0.18), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
		hintLabel.Text = "Entraîne-toi sur ton tapis."
	else
		nextZoneLabel.Text = "TOUTES LES ZONES DÉBLOQUÉES"
		reqLabel.Text = "Tu es au niveau maximum !"
		progressFill.Size = UDim2.fromScale(1, 1)
		hintLabel.Text = "Cherche les oeufs Secret."
	end

	local carrying = player:GetAttribute("CarryingEgg")
	local rarity = player:GetAttribute("CarryingRarity")
	if carrying and carrying ~= "" then
		carryCard.Visible = true
		carryName.Text = carrying .. "  [" .. tostring(rarity) .. "]"
		local rarityInfo = Config.Rarities[rarity]
		if rarityInfo then
			carryName.TextColor3 = rarityInfo.Color
			carryStroke.Color = rarityInfo.Color
		end
	else
		carryCard.Visible = false
	end
end

coins.Changed:Connect(refreshUI)
speed.Changed:Connect(refreshUI)
for _, attr in ipairs({"IncomePerSecond", "PetCount", "BaseLevel", "TrainingLevel", "CarryingEgg", "CarryingRarity", "BaseIndex"}) do
	player:GetAttributeChangedSignal(attr):Connect(refreshUI)
end

notifyRemote.OnClientEvent:Connect(function(message, kind)
	showToast(tostring(message), tostring(kind or "Info"))
	refreshUI()
	refreshShop()
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.B then
		refreshShop()
		openModal(shopModal)
	elseif input.KeyCode == Enum.KeyCode.I then
		openModal(invModal)
	end
end)

refreshUI()

task.delay(1, function()
	showToast("Vole un oeuf, ramène-le à ta base, puis défends tes héros.", "Info")
end)
