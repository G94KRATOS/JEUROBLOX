local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local VisualController = require(script:WaitForChild("VisualController"))

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
	Ink = Color3.fromRGB(26, 29, 37),
	Panel = Color3.fromRGB(35, 39, 49),
	Panel2 = Color3.fromRGB(45, 50, 62),
	White = Color3.fromRGB(250, 251, 253),
	Muted = Color3.fromRGB(168, 176, 195),
	Green = Color3.fromRGB(74, 224, 95),
	Blue = Color3.fromRGB(71, 174, 255),
	Orange = Color3.fromRGB(255, 164, 67),
	Purple = Color3.fromRGB(171, 95, 255),
	Red = Color3.fromRGB(255, 83, 96),
	Yellow = Color3.fromRGB(255, 221, 74),
	Cyan = Color3.fromRGB(78, 220, 236),
}

local function corner(parent, radius)
	local x = Instance.new("UICorner")
	x.CornerRadius = UDim.new(0, radius)
	x.Parent = parent
	return x
end

local function stroke(parent, color, thickness, transparency)
	local x = Instance.new("UIStroke")
	x.Color = color or Color3.new(1, 1, 1)
	x.Thickness = thickness or 1
	x.Transparency = transparency or 0.5
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

local function label(parent, value, size, pos, fontSize, color, font, align)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Size = size
	l.Position = pos or UDim2.new()
	l.Text = value
	l.TextSize = fontSize or 16
	l.TextColor3 = color or C.White
	l.Font = font or Enum.Font.GothamBold
	l.TextXAlignment = align or Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.Parent = parent
	return l
end

local function button(parent, title, color, width)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(width or 150, 48)
	b.BackgroundColor3 = color
	b.Text = title
	b.TextColor3 = C.White
	b.TextSize = 15
	b.Font = Enum.Font.GothamBlack
	b.AutoButtonColor = false
	b.Parent = parent
	corner(b, 12)
	stroke(b, Color3.fromRGB(18, 20, 25), 2, 0.35)

	local glow = Instance.new("Frame")
	glow.Name = "Glow"
	glow.Size = UDim2.new(1, -12, 0, 3)
	glow.Position = UDim2.new(0, 6, 1, -6)
	glow.BackgroundColor3 = C.White
	glow.BackgroundTransparency = 0.72
	glow.BorderSizePixel = 0
	glow.Parent = b
	corner(glow, 3)

	local original = b.Size
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.1), {
			Size = UDim2.new(original.X.Scale, original.X.Offset + 5, original.Y.Scale, original.Y.Offset + 3),
			BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.08),
		}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.1), {
			Size = original,
			BackgroundColor3 = color,
		}):Play()
	end)
	return b
end

local function glassPanel(parent, size, pos, anchor)
	local f = Instance.new("Frame")
	f.Size = size
	f.Position = pos
	f.AnchorPoint = anchor or Vector2.new(0,0)
	f.BackgroundColor3 = C.Panel
	f.BackgroundTransparency = 0.08
	f.Parent = parent
	corner(f, 16)
	stroke(f, Color3.fromRGB(255,255,255), 1.2, 0.78)
	return f
end

-- Mission HUD
local mission = glassPanel(gui, UDim2.fromOffset(540, 76), UDim2.new(0.5, 0, 0, 16), Vector2.new(0.5,0))
local missionTitle = label(mission, "VOLE UNE CAPSULE !", UDim2.new(1,-28,0,32), UDim2.fromOffset(14,9), 20, C.White, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
local worldChip = label(mission, "HUB CENTRAL", UDim2.new(1,-28,0,22), UDim2.fromOffset(14,40), 12, C.Green, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
local missionAccent = Instance.new("Frame")
missionAccent.Size = UDim2.new(1,-22,0,4)
missionAccent.Position = UDim2.new(0,11,1,-8)
missionAccent.BorderSizePixel = 0
missionAccent.BackgroundColor3 = C.Green
missionAccent.Parent = mission
corner(missionAccent,4)
gradient(missionAccent, C.Green, C.Yellow, 0)

-- Side menus
local left = Instance.new("Frame")
left.Position = UDim2.fromOffset(18, 122)
left.Size = UDim2.fromOffset(155, 170)
left.BackgroundTransparency = 1
left.Parent = gui
local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0,9)
leftLayout.Parent = left

local shopButton = button(left, "BOUTIQUE", C.Green, 150)
local indexButton = button(left, "INDEX", C.Blue, 150)
local baseButton = button(left, "MA BASE", C.Orange, 150)

local right = Instance.new("Frame")
right.AnchorPoint = Vector2.new(1,0)
right.Position = UDim2.new(1,-18,0,122)
right.Size = UDim2.fromOffset(155,170)
right.BackgroundTransparency = 1
right.Parent = gui
local rightLayout = Instance.new("UIListLayout")
rightLayout.Padding = UDim.new(0,9)
rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
rightLayout.Parent = right

local worldsButton = button(right, "MONDES", C.Yellow, 150)
worldsButton.TextColor3 = C.Ink
local heroesButton = button(right, "HEROS", C.Purple, 150)
local shieldButton = button(right, "BOUCLIER", C.Cyan, 150)
shieldButton.TextColor3 = C.Ink

-- Stats
local statsCard = glassPanel(gui, UDim2.fromOffset(228, 102), UDim2.new(0,18,1,-18), Vector2.new(0,1))
local speedLabel = label(statsCard, "SPEED 0", UDim2.new(1,-20,0,28), UDim2.fromOffset(12,10), 19, C.Blue, Enum.Font.GothamBlack)
local incomeLabel = label(statsCard, "+$0/s", UDim2.new(1,-20,0,22), UDim2.fromOffset(12,40), 13, C.Yellow, Enum.Font.GothamBlack)
local moneyLabel = label(statsCard, "$0", UDim2.new(1,-20,0,34), UDim2.fromOffset(12,62), 25, C.Green, Enum.Font.GothamBlack)

local baseCard = glassPanel(gui, UDim2.fromOffset(225, 88), UDim2.new(1,-18,1,-18), Vector2.new(1,1))
local heroCountLabel = label(baseCard, "HEROS 0/12", UDim2.new(1,-18,0,30), UDim2.fromOffset(9,10), 14, C.Purple, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
local baseLevelLabel = label(baseCard, "BASE LV.1", UDim2.new(1,-18,0,28), UDim2.fromOffset(9,42), 13, C.Orange, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)

local carryCard = glassPanel(gui, UDim2.fromOffset(430, 72), UDim2.new(0.5,0,1,-18), Vector2.new(0.5,1))
carryCard.Visible = false
local carryStroke = stroke(carryCard, C.Purple, 2.5, 0.05)
local carryName = label(carryCard, "", UDim2.new(1,-20,0,30), UDim2.fromOffset(10,7), 17, C.Purple, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
local carryHint = label(carryCard, "LE HEROS TE SUIT • RETOURNE A TA BASE !", UDim2.new(1,-20,0,24), UDim2.fromOffset(10,39), 12, C.Green, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)

-- Toasts
local toastHolder = Instance.new("Frame")
toastHolder.AnchorPoint = Vector2.new(0.5,0)
toastHolder.Position = UDim2.new(0.5,0,0,98)
toastHolder.Size = UDim2.fromOffset(440,155)
toastHolder.BackgroundTransparency = 1
toastHolder.Parent = gui
local toastLayout = Instance.new("UIListLayout")
toastLayout.Padding = UDim.new(0,7)
toastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
toastLayout.Parent = toastHolder

local function toast(message, kind)
	local color = C.Blue
	if kind == "Success" then color = C.Green end
	if kind == "Error" or kind == "Danger" then color = C.Red end

	local box = Instance.new("TextLabel")
	box.Size = UDim2.fromOffset(390, 42)
	box.BackgroundColor3 = C.Panel
	box.BackgroundTransparency = 0.02
	box.Text = tostring(message)
	box.TextColor3 = C.White
	box.TextSize = 13
	box.Font = Enum.Font.GothamBold
	box.TextWrapped = true
	box.Parent = toastHolder
	corner(box,11)
	stroke(box,color,1.8,0.18)

	box.TextTransparency = 1
	box.BackgroundTransparency = 1
	TweenService:Create(box,TweenInfo.new(0.15),{TextTransparency=0,BackgroundTransparency=0.02}):Play()

	task.delay(3.2,function()
		if not box.Parent then return end
		local t=TweenService:Create(box,TweenInfo.new(0.18),{TextTransparency=1,BackgroundTransparency=1})
		t:Play()
		t.Completed:Wait()
		box:Destroy()
	end)
end

-- Modal shell
local shade = Instance.new("Frame")
shade.Size = UDim2.fromScale(1,1)
shade.BackgroundColor3 = Color3.new(0,0,0)
shade.BackgroundTransparency = 0.42
shade.Visible = false
shade.ZIndex = 40
shade.Parent = gui

local modals = {}
local function modal(titleText, width, height)
	local f = glassPanel(gui, UDim2.fromOffset(width,height), UDim2.fromScale(0.5,0.5), Vector2.new(0.5,0.5))
	f.Visible = false
	f.ZIndex = 50
	f.BackgroundTransparency = 0.01
	stroke(f,Color3.fromRGB(255,255,255),1.2,0.7)

	local title = label(f,titleText,UDim2.new(1,-80,0,42),UDim2.fromOffset(22,14),21,C.White,Enum.Font.GothamBlack)
	title.ZIndex = 51

	local close = button(f,"X",C.Red,42)
	close.Size = UDim2.fromOffset(42,42)
	close.Position = UDim2.new(1,-58,0,12)
	close.ZIndex = 52
	close.MouseButton1Click:Connect(function()
		f.Visible=false
		shade.Visible=false
	end)

	table.insert(modals,f)
	return f
end

local function openModal(target)
	shade.Visible=true
	for _,m in ipairs(modals) do m.Visible=false end
	target.Visible=true
end

local shopModal = modal("AMELIORATIONS",560,350)
local indexModal = modal("INDEX DES HEROS",720,510)
local worldsModal = modal("MONDES ANIME",610,500)

local function upgradeCard(parent,y,titleText,desc,color)
	local card=Instance.new("Frame")
	card.Size=UDim2.new(1,-44,0,105)
	card.Position=UDim2.fromOffset(22,y)
	card.BackgroundColor3=C.Panel2
	card.ZIndex=51
	card.Parent=parent
	corner(card,14)
	stroke(card,color,1.5,0.4)

	local title=label(card,titleText,UDim2.fromOffset(230,28),UDim2.fromOffset(16,11),16,color,Enum.Font.GothamBlack)
	title.ZIndex=52
	local d=label(card,desc,UDim2.fromOffset(290,24),UDim2.fromOffset(16,42),12,C.Muted,Enum.Font.GothamMedium)
	d.ZIndex=52
	local level=label(card,"LV.1",UDim2.fromOffset(120,22),UDim2.fromOffset(16,70),12,C.White,Enum.Font.GothamBold)
	level.ZIndex=52
	local buy=button(card,"$?",color,150)
	buy.Size=UDim2.fromOffset(150,54)
	buy.Position=UDim2.new(1,-168,0.5,-27)
	buy.ZIndex=52
	return level,buy
end

local baseUpgradeLevel,buyBase=upgradeCard(shopModal,76,"REVENU DE BASE","+25% de revenu par niveau",C.Green)
local trainingLevel,buyTraining=upgradeCard(shopModal,198,"TAPIS SPEED","Gagne plus de Speed",C.Blue)

-- Worlds list
local worldsScroll=Instance.new("ScrollingFrame")
worldsScroll.Size=UDim2.new(1,-40,1,-90)
worldsScroll.Position=UDim2.fromOffset(20,72)
worldsScroll.BackgroundTransparency=1
worldsScroll.BorderSizePixel=0
worldsScroll.ScrollBarThickness=4
worldsScroll.ScrollBarImageColor3=C.Muted
worldsScroll.CanvasSize=UDim2.new(0,0,0,#Config.Worlds*64)
worldsScroll.ZIndex=51
worldsScroll.Parent=worldsModal
local worldsLayout=Instance.new("UIListLayout")
worldsLayout.Padding=UDim.new(0,8)
worldsLayout.Parent=worldsScroll

for i,world in ipairs(Config.Worlds) do
	local row=Instance.new("Frame")
	row.Size=UDim2.new(1,-6,0,56)
	row.BackgroundColor3=C.Panel2
	row.ZIndex=52
	row.Parent=worldsScroll
	corner(row,12)
	stroke(row,world.Accent,1.5,0.45)

	local num=label(row,string.format("%02d",i),UDim2.fromOffset(48,56),UDim2.fromOffset(10,0),15,world.Accent,Enum.Font.GothamBlack,Enum.TextXAlignment.Center)
	num.ZIndex=53
	local title=label(row,world.DisplayName,UDim2.fromOffset(280,28),UDim2.fromOffset(65,5),14,C.White,Enum.Font.GothamBlack)
	title.ZIndex=53
	local sub=label(row,world.Name.."  •  x"..tostring(world.IncomeMultiplier or 1).." revenu",UDim2.fromOffset(300,20),UDim2.fromOffset(65,31),11,C.Muted,Enum.Font.GothamMedium)
	sub.ZIndex=53
	local req=label(row,tostring(world.RequiredSpeed).." SPEED",UDim2.fromOffset(140,56),UDim2.new(1,-150,0,0),12,world.Accent,Enum.Font.GothamBlack,Enum.TextXAlignment.Right)
	req.ZIndex=53
end

-- Index scroll
local indexScroll=Instance.new("ScrollingFrame")
indexScroll.Size=UDim2.new(1,-40,1,-88)
indexScroll.Position=UDim2.fromOffset(20,70)
indexScroll.BackgroundTransparency=1
indexScroll.BorderSizePixel=0
indexScroll.ScrollBarThickness=4
indexScroll.ScrollBarImageColor3=C.Muted
indexScroll.ZIndex=51
indexScroll.Parent=indexModal

local grid=Instance.new("UIGridLayout")
grid.CellSize=UDim2.fromOffset(158,72)
grid.CellPadding=UDim2.fromOffset(8,8)
grid.Parent=indexScroll

local function allHeroes()
	local list={}
	for _,world in ipairs(Config.Worlds) do
		for _,hero in ipairs(world.Heroes) do
			table.insert(list,{Name=hero.Name,Rarity=hero.Rarity,WorldKey=world.Key,Accent=world.Accent})
		end
	end
	return list
end

local heroCatalog=allHeroes()
indexScroll.CanvasSize=UDim2.new(0,0,0,math.ceil(#heroCatalog/4)*80)

local function state()
	local ok,result=pcall(function() return requestState:InvokeServer() end)
	if ok and result then return result end
	return {}
end

local function refreshShop()
	local s=state()
	baseUpgradeLevel.Text="LV."..tostring(s.BaseLevel or player:GetAttribute("BaseLevel") or 1)
	trainingLevel.Text="LV."..tostring(s.TrainingLevel or player:GetAttribute("TrainingLevel") or 1)
	buyBase.Text="$"..tostring(s.BaseUpgradeCost or "?")
	buyTraining.Text="$"..tostring(s.TrainingUpgradeCost or "?")
end

local function refreshIndex()
	for _,child in ipairs(indexScroll:GetChildren()) do
		if not child:IsA("UIGridLayout") then child:Destroy() end
	end

	local s=state()
	local owned={}
	for _,hero in ipairs(s.Heroes or {}) do
		owned[hero.Name]=(owned[hero.Name] or 0)+1
	end

	for _,entry in ipairs(heroCatalog) do
		local rarity=Config.Rarities[entry.Rarity]
		local has=owned[entry.Name]
		local card=Instance.new("Frame")
		card.BackgroundColor3=has and C.Panel2 or Color3.fromRGB(40,43,52)
		card.ZIndex=52
		card.Parent=indexScroll
		corner(card,11)
		stroke(card,rarity.Color,1.4,has and 0.35 or 0.72)

		local name=label(card,has and entry.Name or "???",UDim2.new(1,-10,0,28),UDim2.fromOffset(5,7),11,has and C.White or C.Muted,Enum.Font.GothamBlack,Enum.TextXAlignment.Center)
		name.ZIndex=53
		local info=label(card,entry.Rarity..(has and (" x"..tostring(has)) or ""),UDim2.new(1,-10,0,20),UDim2.fromOffset(5,35),10,rarity.Color,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
		info.ZIndex=53
		local world=label(card,entry.WorldKey,UDim2.new(1,-10,0,14),UDim2.fromOffset(5,54),8,entry.Accent,Enum.Font.GothamMedium,Enum.TextXAlignment.Center)
		world.ZIndex=53
	end
end

shopButton.MouseButton1Click:Connect(function()
	refreshShop()
	openModal(shopModal)
end)
indexButton.MouseButton1Click:Connect(function()
	refreshIndex()
	openModal(indexModal)
end)
heroesButton.MouseButton1Click:Connect(function()
	refreshIndex()
	openModal(indexModal)
end)
worldsButton.MouseButton1Click:Connect(function()
	openModal(worldsModal)
end)
baseButton.MouseButton1Click:Connect(function()
	local n=player:GetAttribute("BaseIndex")
	toast(n and ("Ta base : "..tostring(n)) or "Aucune base assignee.",n and "Success" or "Error")
end)
shieldButton.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Shield")
end)
buyBase.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Base")
	task.delay(0.2,refreshShop)
end)
buyTraining.MouseButton1Click:Connect(function()
	shopRemote:FireServer("Training")
	task.delay(0.2,refreshShop)
end)

-- Hatch reveal
local hatchShade=Instance.new("Frame")
hatchShade.Size=UDim2.fromScale(1,1)
hatchShade.BackgroundColor3=Color3.new(0,0,0)
hatchShade.BackgroundTransparency=1
hatchShade.Visible=false
hatchShade.ZIndex=80
hatchShade.Parent=gui

local hatchCard=glassPanel(gui,UDim2.fromOffset(440,235),UDim2.fromScale(0.5,0.5),Vector2.new(0.5,0.5))
hatchCard.Visible=false
hatchCard.ZIndex=81
local hatchStroke=stroke(hatchCard,C.Purple,3,0.05)
local hatchTitle=label(hatchCard,"NOUVEAU HEROS !",UDim2.new(1,-30,0,40),UDim2.fromOffset(15,20),22,C.White,Enum.Font.GothamBlack,Enum.TextXAlignment.Center)
hatchTitle.ZIndex=82
local hatchName=label(hatchCard,"",UDim2.new(1,-30,0,62),UDim2.fromOffset(15,78),30,C.Purple,Enum.Font.GothamBlack,Enum.TextXAlignment.Center)
hatchName.ZIndex=82
local hatchRarity=label(hatchCard,"",UDim2.new(1,-30,0,34),UDim2.fromOffset(15,145),17,C.Purple,Enum.Font.GothamBlack,Enum.TextXAlignment.Center)
hatchRarity.ZIndex=82
local hatchSub=label(hatchCard,"Il genere maintenant de l'argent a ta base.",UDim2.new(1,-30,0,28),UDim2.fromOffset(15,187),11,C.Muted,Enum.Font.GothamMedium,Enum.TextXAlignment.Center)
hatchSub.ZIndex=82

local function playHatch(name,rarityName,rarityColor)
	hatchShade.Visible=true
	hatchCard.Visible=true
	hatchShade.BackgroundTransparency=1
	hatchCard.Size=UDim2.fromOffset(250,140)
	hatchCard.BackgroundTransparency=1
	hatchName.Text=tostring(name)
	hatchRarity.Text=tostring(rarityName)
	hatchName.TextColor3=rarityColor or C.Purple
	hatchRarity.TextColor3=rarityColor or C.Purple
	hatchStroke.Color=rarityColor or C.Purple

	TweenService:Create(hatchShade,TweenInfo.new(0.16),{BackgroundTransparency=0.5}):Play()
	TweenService:Create(hatchCard,TweenInfo.new(0.25,Enum.EasingStyle.Back),{Size=UDim2.fromOffset(440,235),BackgroundTransparency=0.02}):Play()

	task.delay(2.25,function()
		local t=TweenService:Create(hatchShade,TweenInfo.new(0.2),{BackgroundTransparency=1})
		t:Play()
		TweenService:Create(hatchCard,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
		t.Completed:Wait()
		hatchShade.Visible=false
		hatchCard.Visible=false
	end)
end

local leaderstats=player:WaitForChild("leaderstats")
local coins=leaderstats:WaitForChild("Coins")
local speedStat=leaderstats:WaitForChild("Speed")

local currentWorld
local function detectWorld()
	local character=player.Character
	local root=character and character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	if root.Position.Z < 30 then return nil end

	local nearest
	local nearestDistance=math.huge
	for _,world in ipairs(Config.Worlds) do
		local d=math.abs(root.Position.Z-world.CenterZ)
		if d < nearestDistance then
			nearest=world
			nearestDistance=d
		end
	end
	if nearestDistance <= 145 then return nearest end
	return nil
end

local function refreshHUD()
	local income=player:GetAttribute("IncomePerSecond") or 0
	local heroes=player:GetAttribute("HeroCount") or 0
	local baseLevel=player:GetAttribute("BaseLevel") or 1
	local carrying=player:GetAttribute("CarryingName") or ""
	local carryingRarity=player:GetAttribute("CarryingRarity") or ""

	moneyLabel.Text="$"..tostring(coins.Value)
	incomeLabel.Text="+$"..tostring(income).."/s"
	speedLabel.Text="SPEED "..tostring(speedStat.Value)
	heroCountLabel.Text="HEROS "..tostring(heroes).."/"..tostring(Config.MaxHeroes)
	baseLevelLabel.Text="BASE LV."..tostring(baseLevel)

	if player:GetAttribute("ShieldActive") then
		shieldButton.Text="BOUCLIER ON"
		shieldButton.BackgroundColor3=C.Green
	else
		shieldButton.Text="BOUCLIER"
		shieldButton.BackgroundColor3=C.Cyan
	end

	if carrying ~= "" then
		carryCard.Visible=true
		carryName.Text=carrying.."  ["..carryingRarity.."]"
		local rd=Config.Rarities[carryingRarity]
		if rd then
			carryName.TextColor3=rd.Color
			carryStroke.Color=rd.Color
		end
		missionTitle.Text="RAMENE-LE A TA BASE !"
		missionAccent.BackgroundColor3=C.Orange
	else
		carryCard.Visible=false
		if currentWorld then
			missionTitle.Text="VOLE UNE CAPSULE !"
			worldChip.Text=currentWorld.DisplayName.."  •  "..tostring(currentWorld.RequiredSpeed).." SPEED"
			worldChip.TextColor3=currentWorld.Accent
			missionAccent.BackgroundColor3=currentWorld.Accent
		else
			missionTitle.Text="CHOISIS UN MONDE • VOLE UNE CAPSULE"
			local nextLocked
			for _, world in ipairs(Config.Worlds) do
				if speedStat.Value < world.RequiredSpeed then
					nextLocked = world
					break
				end
			end
			if nextLocked then
				worldChip.Text="PROCHAIN : "..nextLocked.DisplayName.."  •  "..tostring(nextLocked.RequiredSpeed).." SPEED"
				worldChip.TextColor3=nextLocked.Accent
				missionAccent.BackgroundColor3=nextLocked.Accent
			else
				worldChip.Text="TOUS LES MONDES DEBLOQUES"
				worldChip.TextColor3=C.Green
				missionAccent.BackgroundColor3=C.Green
			end
		end
	end
end

coins.Changed:Connect(refreshHUD)
speedStat.Changed:Connect(refreshHUD)
for _,attr in ipairs({"IncomePerSecond","HeroCount","BaseLevel","TrainingLevel","CarryingName","CarryingRarity","CarryingWorld","BaseIndex","ShieldActive"}) do
	player:GetAttributeChangedSignal(attr):Connect(refreshHUD)
end

notifyRemote.OnClientEvent:Connect(function(message,kind)
	toast(message,kind)
	refreshHUD()
end)

hatchRemote.OnClientEvent:Connect(function(name,rarityName,rarityColor)
	playHatch(name,rarityName,rarityColor)
	refreshHUD()
end)

UserInputService.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.KeyCode==Enum.KeyCode.B then
		refreshShop()
		openModal(shopModal)
	elseif input.KeyCode==Enum.KeyCode.I then
		refreshIndex()
		openModal(indexModal)
	end
end)

local accumulator=0
RunService.RenderStepped:Connect(function(dt)
	accumulator+=dt
	if accumulator < 0.35 then return end
	accumulator=0
	currentWorld=detectWorld()
	refreshHUD()
end)

VisualController.Start(player, Config)

refreshHUD()
task.delay(1.2,function()
	toast("Gagne de la Speed, vole une capsule et ramène le héros qui te suit.", "Success")
end)
