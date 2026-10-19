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

local C = {
	Dark = Color3.fromRGB(30, 34, 44),
	Panel = Color3.fromRGB(40, 45, 56),
	Green = Color3.fromRGB(76, 220, 73),
	Blue = Color3.fromRGB(64, 185, 255),
	Orange = Color3.fromRGB(255, 169, 55),
	Red = Color3.fromRGB(255, 78, 80),
	Purple = Color3.fromRGB(174, 87, 255),
	Yellow = Color3.fromRGB(255, 226, 72),
	White = Color3.fromRGB(255, 255, 255),
	Muted = Color3.fromRGB(190, 198, 210),
}

local function corner(parent, radius)
	local x = Instance.new("UICorner")
	x.CornerRadius = UDim.new(0, radius)
	x.Parent = parent
	return x
end

local function stroke(parent, color, thickness, transparency)
	local x = Instance.new("UIStroke")
	x.Color = color or Color3.new(0,0,0)
	x.Thickness = thickness or 2
	x.Transparency = transparency or 0
	x.Parent = parent
	return x
end

local function text(parent, value, size, pos, textSize, color, font, align)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Size = size
	l.Position = pos or UDim2.new()
	l.Text = value
	l.TextSize = textSize or 18
	l.TextColor3 = color or C.White
	l.Font = font or Enum.Font.GothamBold
	l.TextXAlignment = align or Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.TextStrokeTransparency = 0.8
	l.Parent = parent
	return l
end

local function actionButton(parent, title, color, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(132, 47)
	b.Position = UDim2.fromOffset(14, y)
	b.BackgroundColor3 = color
	b.Text = title
	b.TextColor3 = C.White
	b.TextSize = 18
	b.Font = Enum.Font.GothamBlack
	b.AutoButtonColor = false
	b.Parent = parent
	corner(b, 7)
	stroke(b, Color3.fromRGB(35,35,35), 3, 0.15)

	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.1), {Size = UDim2.fromOffset(138, 50)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.1), {Size = UDim2.fromOffset(132, 47)}):Play()
	end)
	return b
end

local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(160, 190)
menu.Position = UDim2.fromOffset(0, 120)
menu.BackgroundTransparency = 1
menu.Parent = gui

local shopButton = actionButton(menu, "SHOP", C.Green, 0)
local indexButton = actionButton(menu, "INDEX", C.Blue, 55)
local baseButton = actionButton(menu, "MY BASE", C.Orange, 110)

local money = text(gui, "$0", UDim2.fromOffset(245, 52), UDim2.new(0, 18, 1, -77), 30, Color3.fromRGB(65, 239, 95), Enum.Font.GothamBlack)
money.TextStrokeTransparency = 0.35

local income = text(gui, "+$0/s", UDim2.fromOffset(170, 30), UDim2.new(0, 22, 1, -108), 18, C.Yellow, Enum.Font.GothamBlack)

local speed = text(gui, "SPEED 0", UDim2.fromOffset(245, 40), UDim2.new(0, 18, 1, -145), 23, C.Blue, Enum.Font.GothamBlack)

local progress = Instance.new("Frame")
progress.AnchorPoint = Vector2.new(0.5, 0)
progress.Position = UDim2.new(0.5, 0, 0, 16)
progress.Size = UDim2.fromOffset(420, 44)
progress.BackgroundColor3 = Color3.fromRGB(36, 39, 48)
progress.BackgroundTransparency = 0.08
progress.Parent = gui
corner(progress, 10)
stroke(progress, Color3.fromRGB(255,255,255), 1, 0.7)

local zoneText = text(progress, "NEXT: BLOSSOM VILLAGE", UDim2.new(1, -24, 1, 0), UDim2.fromOffset(12, 0), 15, C.White, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)

local progressBack = Instance.new("Frame")
progressBack.Size = UDim2.new(1, -20, 0, 5)
progressBack.Position = UDim2.new(0, 10, 1, -7)
progressBack.BackgroundColor3 = Color3.fromRGB(78,82,91)
progressBack.BorderSizePixel = 0
progressBack.Parent = progress
corner(progressBack, 4)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.fromScale(0, 1)
progressFill.BackgroundColor3 = C.Green
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBack
corner(progressFill, 4)

local rightHud = Instance.new("Frame")
rightHud.AnchorPoint = Vector2.new(1, 0)
rightHud.Position = UDim2.new(1, -18, 0, 20)
rightHud.Size = UDim2.fromOffset(170, 84)
rightHud.BackgroundColor3 = C.Dark
rightHud.BackgroundTransparency = 0.1
rightHud.Parent = gui
corner(rightHud, 10)
stroke(rightHud, Color3.fromRGB(255,255,255), 1, 0.75)

local heroesText = text(rightHud, "HEROES 0/12", UDim2.new(1, -18, 0, 30), UDim2.fromOffset(10, 8), 15, C.White, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
local baseLevelText = text(rightHud, "BASE LV.1", UDim2.new(1, -18, 0, 28), UDim2.fromOffset(10, 42), 14, C.Yellow, Enum.Font.GothamBold, Enum.TextXAlignment.Center)

local carry = Instance.new("Frame")
carry.AnchorPoint = Vector2.new(0.5, 1)
carry.Position = UDim2.new(0.5, 0, 1, -20)
carry.Size = UDim2.fromOffset(390, 68)
carry.BackgroundColor3 = C.Dark
carry.Visible = false
carry.Parent = gui
corner(carry, 12)
local carryStroke = stroke(carry, C.Purple, 3, 0.05)

local carryName = text(carry, "", UDim2.new(1, -20, 0, 30), UDim2.fromOffset(10, 7), 17, C.White, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
local carryHint = text(carry, "RETURN TO YOUR BASE", UDim2.new(1, -20, 0, 22), UDim2.fromOffset(10, 38), 12, C.Green, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)

local toastHolder = Instance.new("Frame")
toastHolder.AnchorPoint = Vector2.new(0.5, 0)
toastHolder.Position = UDim2.new(0.5, 0, 0, 70)
toastHolder.Size = UDim2.fromOffset(440, 160)
toastHolder.BackgroundTransparency = 1
toastHolder.Parent = gui

local toastLayout = Instance.new("UIListLayout")
toastLayout.Padding = UDim.new(0, 7)
toastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
toastLayout.Parent = toastHolder

local function toast(message, kind)
	local color = C.Blue
	if kind == "Success" then color = C.Green end
	if kind == "Error" or kind == "Danger" then color = C.Red end

	local box = Instance.new("TextLabel")
	box.Size = UDim2.fromOffset(390, 42)
	box.BackgroundColor3 = C.Dark
	box.BackgroundTransparency = 0.04
	box.Text = tostring(message)
	box.TextColor3 = C.White
	box.TextSize = 14
	box.Font = Enum.Font.GothamBold
	box.Parent = toastHolder
	corner(box, 8)
	stroke(box, color, 2, 0.1)

	box.TextTransparency = 1
	box.BackgroundTransparency = 1
	TweenService:Create(box, TweenInfo.new(0.15), {TextTransparency = 0, BackgroundTransparency = 0.04}):Play()
	task.delay(3, function()
		if not box.Parent then return end
		local t = TweenService:Create(box, TweenInfo.new(0.16), {TextTransparency = 1, BackgroundTransparency = 1})
		t:Play()
		t.Completed:Wait()
		box:Destroy()
	end)
end

local shade = Instance.new("Frame")
shade.Size = UDim2.fromScale(1,1)
shade.BackgroundColor3 = Color3.new(0,0,0)
shade.BackgroundTransparency = 0.45
shade.Visible = false
shade.ZIndex = 40
shade.Parent = gui

local function modal(titleText, width, height)
	local f = Instance.new("Frame")
	f.AnchorPoint = Vector2.new(0.5,0.5)
	f.Position = UDim2.fromScale(0.5,0.5)
	f.Size = UDim2.fromOffset(width,height)
	f.BackgroundColor3 = Color3.fromRGB(245,247,252)
	f.Visible = false
	f.ZIndex = 50
	f.Parent = gui
	corner(f, 14)
	stroke(f, Color3.fromRGB(45,49,61), 3, 0.1)

	local title = text(f, titleText, UDim2.new(1,-70,0,44), UDim2.fromOffset(20,12), 22, Color3.fromRGB(35,38,48), Enum.Font.GothamBlack)
	title.ZIndex = 51

	local close = Instance.new("TextButton")
	close.Size = UDim2.fromOffset(40,40)
	close.Position = UDim2.new(1,-52,0,12)
	close.BackgroundColor3 = C.Red
	close.Text = "X"
	close.TextColor3 = C.White
	close.Font = Enum.Font.GothamBlack
	close.TextSize = 18
	close.ZIndex = 52
	close.Parent = f
	corner(close, 8)
	close.MouseButton1Click:Connect(function()
		f.Visible = false
		shade.Visible = false
	end)
	return f
end

local shopModal = modal("UPGRADES", 540, 330)
local indexModal = modal("PET INDEX", 520, 300)

local function card(parent, y, titleText, desc, color)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1,-40,0,100)
	f.Position = UDim2.fromOffset(20,y)
	f.BackgroundColor3 = Color3.fromRGB(229,233,241)
	f.ZIndex = 51
	f.Parent = parent
	corner(f, 10)
	stroke(f, color, 2, 0.25)
	local title = text(f,titleText,UDim2.fromOffset(170,28),UDim2.fromOffset(14,10),17,color,Enum.Font.GothamBlack)
	title.ZIndex = 52
	local d = text(f,desc,UDim2.fromOffset(270,24),UDim2.fromOffset(14,42),12,Color3.fromRGB(80,87,101),Enum.Font.GothamMedium)
	d.ZIndex = 52
	local level = text(f,"LV.1",UDim2.fromOffset(120,22),UDim2.fromOffset(14,68),12,Color3.fromRGB(45,49,60),Enum.Font.GothamBold)
	level.ZIndex = 52
	local buy = Instance.new("TextButton")
	buy.Size = UDim2.fromOffset(140,52)
	buy.Position = UDim2.new(1,-154,0.5,-26)
	buy.BackgroundColor3 = color
	buy.Text = "$?"
	buy.TextColor3 = C.White
	buy.Font = Enum.Font.GothamBlack
	buy.TextSize = 17
	buy.ZIndex = 52
	buy.Parent = f
	corner(buy, 8)
	stroke(buy, Color3.fromRGB(40,40,40), 2, 0.25)
	return level,buy
end

local baseLevel, buyBase = card(shopModal,72,"BASE INCOME","+25% cash per level",C.Green)
local trainLevel, buyTrain = card(shopModal,186,"TREADMILL","Gain Speed faster",C.Blue)

local indexCount = text(indexModal,"0 / 12 HEROES",UDim2.new(1,-40,0,40),UDim2.fromOffset(20,74),24,C.Purple,Enum.Font.GothamBlack,Enum.TextXAlignment.Center)
indexCount.ZIndex = 51
local indexIncome = text(indexModal,"$0 / SECOND",UDim2.new(1,-40,0,35),UDim2.fromOffset(20,120),20,Color3.fromRGB(50,174,76),Enum.Font.GothamBlack,Enum.TextXAlignment.Center)
indexIncome.ZIndex = 51
local rarity = text(indexModal,"COMMON  •  RARE  •  EPIC  •  LEGENDARY  •  MYTHIC  •  SECRET",UDim2.new(1,-40,0,60),UDim2.fromOffset(20,185),12,Color3.fromRGB(76,83,99),Enum.Font.GothamBold,Enum.TextXAlignment.Center)
rarity.TextWrapped = true
rarity.ZIndex = 51

local function open(which)
	shade.Visible = true
	shopModal.Visible = false
	indexModal.Visible = false
	which.Visible = true
end

local function refreshShop()
	local ok,state = pcall(function() return requestState:InvokeServer() end)
	if not ok or not state then return end
	baseLevel.Text = "LV." .. tostring(player:GetAttribute("BaseLevel") or 1)
	trainLevel.Text = "LV." .. tostring(player:GetAttribute("TrainingLevel") or 1)
	buyBase.Text = "$" .. tostring(state.BaseUpgradeCost or "?")
	buyTrain.Text = "$" .. tostring(state.TrainingUpgradeCost or "?")
end

shopButton.MouseButton1Click:Connect(function()
	refreshShop()
	open(shopModal)
end)

indexButton.MouseButton1Click:Connect(function()
	open(indexModal)
end)

baseButton.MouseButton1Click:Connect(function()
	local n = player:GetAttribute("BaseIndex")
	toast(n and ("YOUR BASE: " .. tostring(n)) or "No base assigned.", n and "Success" or "Error")
end)

buyBase.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Base")
	task.delay(0.25, refreshShop)
end)

buyTrain.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Training")
	task.delay(0.25, refreshShop)
end)

shade.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		shade.Visible = false
		shopModal.Visible = false
		indexModal.Visible = false
	end
end)

local stats = player:WaitForChild("leaderstats")
local coins = stats:WaitForChild("Coins")
local speedStat = stats:WaitForChild("Speed")

local function nextZone(value)
	local prev = 0
	for _,zone in ipairs(Config.Zones) do
		if value < zone.RequiredSpeed then return zone,prev end
		prev = zone.RequiredSpeed
	end
	return nil,prev
end

local function refresh()
	local incomeValue = player:GetAttribute("IncomePerSecond") or 0
	local petCount = player:GetAttribute("PetCount") or 0
	local baseLv = player:GetAttribute("BaseLevel") or 1

	money.Text = "$" .. tostring(coins.Value)
	income.Text = "+$" .. tostring(incomeValue) .. "/s"
	speed.Text = "SPEED " .. tostring(speedStat.Value)
	heroesText.Text = "HEROES " .. tostring(petCount) .. "/" .. tostring(Config.MaxPets)
	baseLevelText.Text = "BASE LV." .. tostring(baseLv)
	indexCount.Text = tostring(petCount) .. " / " .. tostring(Config.MaxPets) .. " HEROES"
	indexIncome.Text = "$" .. tostring(incomeValue) .. " / SECOND"

	local zone,prev = nextZone(speedStat.Value)
	if zone then
		zoneText.Text = "NEXT: " .. string.upper(zone.Name) .. "   •   " .. tostring(zone.RequiredSpeed) .. " SPEED"
		local pct = math.clamp((speedStat.Value-prev)/math.max(1,zone.RequiredSpeed-prev),0,1)
		TweenService:Create(progressFill,TweenInfo.new(0.15),{Size=UDim2.new(pct,0,1,0)}):Play()
	else
		zoneText.Text = "ALL ZONES UNLOCKED"
		progressFill.Size = UDim2.fromScale(1,1)
	end

	local carried = player:GetAttribute("CarryingEgg")
	local rarityName = player:GetAttribute("CarryingRarity")
	if carried and carried ~= "" then
		carry.Visible = true
		carryName.Text = tostring(carried) .. "  [" .. tostring(rarityName) .. "]"
		local data = Config.Rarities[rarityName]
		if data then
			carryName.TextColor3 = data.Color
			carryStroke.Color = data.Color
		end
	else
		carry.Visible = false
	end
end

coins.Changed:Connect(refresh)
speedStat.Changed:Connect(refresh)
for _,name in ipairs({"IncomePerSecond","PetCount","BaseLevel","TrainingLevel","CarryingEgg","CarryingRarity","BaseIndex"}) do
	player:GetAttributeChangedSignal(name):Connect(refresh)
end

notifyRemote.OnClientEvent:Connect(function(message,kind)
	toast(message,kind)
	refresh()
end)

UserInputService.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.B then
		refreshShop()
		open(shopModal)
	elseif input.KeyCode == Enum.KeyCode.I then
		open(indexModal)
	end
end)

refresh()
task.delay(1.2,function()
	toast("Steal an egg, escape the guardian, and bring it home.", "Success")
end)
