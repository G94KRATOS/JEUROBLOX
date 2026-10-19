local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("AnimeEggUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeEggUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function corner(parent, px)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, px)
	c.Parent = parent
end

local function stroke(parent, transparency)
	local s = Instance.new("UIStroke")
	s.Thickness = 1.5
	s.Transparency = transparency or 0.35
	s.Color = Color3.fromRGB(196, 135, 255)
	s.Parent = parent
end

local function makeLabel(parent, text, size, pos, textSize, align)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = size
	label.Position = pos
	label.Text = text
	label.TextColor3 = Color3.fromRGB(245, 245, 255)
	label.TextSize = textSize
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = align or Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end

local top = Instance.new("Frame")
top.AnchorPoint = Vector2.new(0.5, 0)
top.Position = UDim2.fromScale(0.5, 0.025)
top.Size = UDim2.new(0, 520, 0, 64)
top.BackgroundColor3 = Color3.fromRGB(20, 21, 31)
top.BackgroundTransparency = 0.08
top.Parent = gui
corner(top, 18)
stroke(top, 0.25)

makeLabel(top, "ANIME EGG RUSH", UDim2.new(0, 210, 1, 0), UDim2.fromOffset(22, 0), 19)

local coinsLabel = makeLabel(top, "COINS 0", UDim2.new(0, 120, 1, 0), UDim2.fromOffset(270, 0), 18, Enum.TextXAlignment.Center)
coinsLabel.TextColor3 = Color3.fromRGB(255, 220, 90)

local eggsLabel = makeLabel(top, "EGGS 0", UDim2.new(0, 110, 1, 0), UDim2.fromOffset(395, 0), 18, Enum.TextXAlignment.Center)
eggsLabel.TextColor3 = Color3.fromRGB(226, 185, 255)

local side = Instance.new("Frame")
side.AnchorPoint = Vector2.new(0, 0.5)
side.Position = UDim2.new(0, 18, 0.5, 0)
side.Size = UDim2.fromOffset(150, 132)
side.BackgroundTransparency = 1
side.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = side

local function menuButton(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(150, 56)
	b.BackgroundColor3 = Color3.fromRGB(28, 30, 43)
	b.Text = text
	b.TextColor3 = Color3.fromRGB(245, 245, 255)
	b.TextSize = 16
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = side
	corner(b, 14)
	stroke(b, 0.5)

	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(55, 40, 78)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28, 30, 43)}):Play()
	end)
	return b
end

local shop = menuButton("BOUTIQUE")
local inventory = menuButton("INVENTAIRE")

local info = Instance.new("Frame")
info.AnchorPoint = Vector2.new(0.5, 1)
info.Position = UDim2.new(0.5, 0, 1, -20)
info.Size = UDim2.fromOffset(430, 64)
info.BackgroundColor3 = Color3.fromRGB(19, 20, 29)
info.BackgroundTransparency = 0.08
info.Parent = gui
corner(info, 18)
stroke(info, 0.35)

makeLabel(info, "PROCHAIN OEUF", UDim2.new(0, 145, 1, 0), UDim2.fromOffset(18, 0), 14)
local hint = makeLabel(info, "Centre de la map • +25 coins", UDim2.new(0, 245, 1, 0), UDim2.fromOffset(165, 0), 14, Enum.TextXAlignment.Center)
hint.TextColor3 = Color3.fromRGB(205, 164, 255)

local toast = Instance.new("TextLabel")
toast.AnchorPoint = Vector2.new(0.5, 0)
toast.Position = UDim2.new(0.5, 0, 0, 105)
toast.Size = UDim2.fromOffset(330, 44)
toast.BackgroundColor3 = Color3.fromRGB(31, 24, 45)
toast.BackgroundTransparency = 0.05
toast.TextColor3 = Color3.fromRGB(245, 235, 255)
toast.Text = ""
toast.TextSize = 14
toast.Font = Enum.Font.GothamBold
toast.Visible = false
toast.Parent = gui
corner(toast, 12)

local function notify(message)
	toast.Text = message
	toast.Visible = true
	toast.TextTransparency = 1
	toast.BackgroundTransparency = 1
	TweenService:Create(toast, TweenInfo.new(0.18), {TextTransparency = 0, BackgroundTransparency = 0.05}):Play()
	task.delay(1.8, function()
		TweenService:Create(toast, TweenInfo.new(0.2), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
		task.wait(0.2)
		toast.Visible = false
	end)
end

shop.MouseButton1Click:Connect(function()
	notify("Boutique en construction")
end)

inventory.MouseButton1Click:Connect(function()
	notify("Inventaire en construction")
end)

local stats = player:WaitForChild("leaderstats")
local coins = stats:WaitForChild("Coins")
local eggs = stats:WaitForChild("Eggs")

local function refresh()
	coinsLabel.Text = "COINS " .. tostring(coins.Value)
	eggsLabel.Text = "EGGS " .. tostring(eggs.Value)
end

coins.Changed:Connect(refresh)
eggs.Changed:Connect(refresh)
refresh()
