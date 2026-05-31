local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local LOGO_TEXT = "Zengor"

local IMAGE_ID = "rbxassetid://88945936113799"
local SOUND_ID = "rbxassetid://127022251074808"

--------------------------------------------------
-- SOUND
--------------------------------------------------

local Sound = Instance.new("Sound")
Sound.SoundId = SOUND_ID
Sound.Volume = 1
Sound.Parent = workspace

--------------------------------------------------
-- BLUR
--------------------------------------------------

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

TweenService:Create(
	Blur,
	TweenInfo.new(1.2, Enum.EasingStyle.Quint),
	{Size = 45}
):Play()

--------------------------------------------------
-- GUI
--------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZengorIntro"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

--------------------------------------------------
-- GROUP (CENTRADO REAL)
--------------------------------------------------

local Group = Instance.new("Frame")
Group.AnchorPoint = Vector2.new(0.5, 0.5)
Group.Position = UDim2.fromScale(0.5, 0.5)
Group.Size = UDim2.fromOffset(1000, 300)
Group.BackgroundTransparency = 1
Group.Parent = Gui

--------------------------------------------------
-- IMAGE (más cerca del texto)
--------------------------------------------------

local Icon = Instance.new("ImageLabel")
Icon.BackgroundTransparency = 1
Icon.AnchorPoint = Vector2.new(0, 0.5)
Icon.Position = UDim2.new(0.30, 0, 0.5, 0)
Icon.Size = UDim2.fromOffset(150, 150)
Icon.Image = IMAGE_ID
Icon.ImageTransparency = 1
Icon.Parent = Group

--------------------------------------------------
-- TEXT
--------------------------------------------------

local Logo = Instance.new("TextLabel")
Logo.AnchorPoint = Vector2.new(0, 0.5)
Logo.Position = UDim2.new(0.30, 0, 0.5, 0)
Logo.Size = UDim2.fromOffset(600, 220)

Logo.BackgroundTransparency = 1
Logo.Text = ""
Logo.TextScaled = true
Logo.Font = Enum.Font.Montserrat

Logo.TextColor3 = Color3.new(1,1,1)
Logo.TextTransparency = 1

Logo.Parent = Group

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.new(1,1,1)
Stroke.Thickness = 1
Stroke.Transparency = 0.85
Stroke.Parent = Logo

--------------------------------------------------
-- APARICIÓN LETRA A LETRA
--------------------------------------------------

task.wait(0.6)

TweenService:Create(
	Icon,
	TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{ImageTransparency = 0}
):Play()

local Word = LOGO_TEXT

for i = 1, #Word do
	Logo.Text = Word:sub(1, i)

	TweenService:Create(
		Logo,
		TweenInfo.new(0.18, Enum.EasingStyle.Quint),
		{TextTransparency = 0}
	):Play()

	task.wait(0.15)
end

--------------------------------------------------
-- SONIDO (cuando texto completo)
--------------------------------------------------

task.wait(0.2)
Sound:Play()

--------------------------------------------------
-- ECO VISUAL
--------------------------------------------------

for i = 1, 4 do
	local Echo = Logo:Clone()
	Echo.Parent = Group

	Echo.TextTransparency = 0.3 + (i * 0.15)
	Echo.TextColor3 = Color3.new(1,1,1)

	Echo.Position = Logo.Position + UDim2.fromOffset(0, i * 5)
	Echo.ZIndex = Logo.ZIndex - 1

	TweenService:Create(
		Echo,
		TweenInfo.new(0.9, Enum.EasingStyle.Quart),
		{
			TextTransparency = 1,
			Position = Echo.Position + UDim2.fromOffset(0, 35)
		}
	):Play()

	Debris:AddItem(Echo, 1)
end

--------------------------------------------------
-- REFLEJO CRISTAL
--------------------------------------------------

task.wait(0.3)

local Shine = Instance.new("Frame")
Shine.AnchorPoint = Vector2.new(0.5, 0.5)
Shine.Size = UDim2.new(0, 400, 2, 0)
Shine.Position = UDim2.new(-0.5, 0, 0.5, 0)
Shine.Rotation = 20
Shine.BackgroundColor3 = Color3.new(1,1,1)
Shine.BackgroundTransparency = 0.92
Shine.BorderSizePixel = 0
Shine.Parent = Gui

local Gradient = Instance.new("UIGradient")
Gradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0,1),
	NumberSequenceKeypoint.new(0.4,0.9),
	NumberSequenceKeypoint.new(0.5,0.05),
	NumberSequenceKeypoint.new(0.6,0.9),
	NumberSequenceKeypoint.new(1,1)
})
Gradient.Parent = Shine

TweenService:Create(
	Shine,
	TweenInfo.new(2, Enum.EasingStyle.Quint),
	{Position = UDim2.new(1.5, 0, 0.5, 0)}
):Play()

--------------------------------------------------
-- BRILLO SUTIL
--------------------------------------------------

TweenService:Create(
	Logo,
	TweenInfo.new(0.2),
	{TextColor3 = Color3.fromRGB(240,240,240)}
):Play()

task.wait(0.2)

TweenService:Create(
	Logo,
	TweenInfo.new(0.3),
	{TextColor3 = Color3.new(1,1,1)}
):Play()

--------------------------------------------------
-- ZOOM FINAL
--------------------------------------------------

task.wait(1.2)

TweenService:Create(
	Group,
	TweenInfo.new(1, Enum.EasingStyle.Quart),
	{Size = UDim2.fromOffset(1080, 320)}
):Play()

--------------------------------------------------
-- FADE OUT
--------------------------------------------------

task.wait(2)

TweenService:Create(Logo, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
TweenService:Create(Icon, TweenInfo.new(0.8), {ImageTransparency = 1}):Play()
TweenService:Create(Blur, TweenInfo.new(1), {Size = 0}):Play()

task.wait(1)

Gui:Destroy()
Blur:Destroy()
Sound:Destroy()
