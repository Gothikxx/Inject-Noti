local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local LOGO_TEXT = "Zengor"
local FONT = Enum.Font.Montserrat
local FONT_SIZE = 160
local ICON_SIZE = 150
local GAP = 25 -- separación icono-texto

local IMAGE_ID = "rbxassetid://88945936113799"
local SOUND_ID = "rbxassetid://127022251074808"

local TYPE_SPEED = 0.15
local TYPE_TWEEN = 0.18

--------------------------------------------------
-- LIMPIEZA SI YA EXISTE (evita intros duplicadas)
--------------------------------------------------

local old = PlayerGui:FindFirstChild("ZengorIntro")
if old then old:Destroy() end

--------------------------------------------------
-- SONIDO
--------------------------------------------------

local Sound = Instance.new("Sound")
Sound.SoundId = SOUND_ID
Sound.Volume = 1
Sound.Parent = SoundService
Debris:AddItem(Sound, 30) -- respaldo de limpieza

--------------------------------------------------
-- BLUR
--------------------------------------------------

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

TweenService:Create(Blur, TweenInfo.new(1.2, Enum.EasingStyle.Quint), {Size = 45}):Play()

--------------------------------------------------
-- CÁLCULO DE TAMAÑO REAL (centrado garantizado)
--------------------------------------------------

local textBounds = TextService:GetTextSize(LOGO_TEXT, FONT_SIZE, FONT, Vector2.new(math.huge, FONT_SIZE))
local totalWidth = ICON_SIZE + GAP + textBounds.X
local groupHeight = math.max(ICON_SIZE, textBounds.Y) + 40

--------------------------------------------------
-- GUI
--------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZengorIntro"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 999
Gui.Parent = PlayerGui

-- Grupo centrado en pantalla, tamaño exacto al contenido
local Group = Instance.new("Frame")
Group.AnchorPoint = Vector2.new(0.5, 0.5)
Group.Position = UDim2.fromScale(0.5, 0.5)
Group.Size = UDim2.fromOffset(totalWidth, groupHeight)
Group.BackgroundTransparency = 1
Group.Parent = Gui

-- Icono a la izquierda
local Icon = Instance.new("ImageLabel")
Icon.BackgroundTransparency = 1
Icon.AnchorPoint = Vector2.new(0, 0.5)
Icon.Position = UDim2.new(0, 0, 0.5, 0)
Icon.Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
Icon.Image = IMAGE_ID
Icon.ImageTransparency = 1
Icon.Parent = Group

-- Texto a la derecha del icono
local Logo = Instance.new("TextLabel")
Logo.AnchorPoint = Vector2.new(0, 0.5)
Logo.Position = UDim2.new(0, ICON_SIZE + GAP, 0.5, -textBounds.Y * 0.06)
Logo.Size = UDim2.fromOffset(textBounds.X + 10, textBounds.Y)
Logo.BackgroundTransparency = 1
Logo.Text = ""
Logo.Font = FONT
Logo.TextSize = FONT_SIZE
Logo.TextColor3 = Color3.new(1, 1, 1)
Logo.TextTransparency = 1
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = Group

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.new(1, 1, 1)
Stroke.Thickness = 1
Stroke.Transparency = 0.85
Stroke.Parent = Logo

--------------------------------------------------
-- APARICIÓN: ICONO + LETRA A LETRA
--------------------------------------------------

task.wait(0.6)

TweenService:Create(
	Icon,
	TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{ImageTransparency = 0}
):Play()

for i = 1, #LOGO_TEXT do
	Logo.Text = LOGO_TEXT:sub(1, i)

	-- Fade-in solo la primera letra, luego se mantiene visible
	if i == 1 then
		TweenService:Create(
			Logo,
			TweenInfo.new(TYPE_TWEEN, Enum.EasingStyle.Quint),
			{TextTransparency = 0}
		):Play()
	end

	task.wait(TYPE_SPEED)
end

--------------------------------------------------
-- SONIDO (cuando el texto está completo)
--------------------------------------------------

task.wait(0.2)
Sound:Play()

--------------------------------------------------
-- REFLEJO CRISTAL (barrido de luz)
--------------------------------------------------

task.wait(0.3)

local Shine = Instance.new("Frame")
Shine.AnchorPoint = Vector2.new(0.5, 0.5)
Shine.Size = UDim2.new(0, 400, 2, 0)
Shine.Position = UDim2.new(-0.5, 0, 0.5, 0)
Shine.Rotation = 20
Shine.BackgroundColor3 = Color3.new(1, 1, 1)
Shine.BackgroundTransparency = 0.92
Shine.BorderSizePixel = 0
Shine.Parent = Gui

local Gradient = Instance.new("UIGradient")
Gradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.4, 0.9),
	NumberSequenceKeypoint.new(0.5, 0.05),
	NumberSequenceKeypoint.new(0.6, 0.9),
	NumberSequenceKeypoint.new(1, 1),
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
	{TextColor3 = Color3.fromRGB(240, 240, 240)}
):Play()

task.wait(0.2)

TweenService:Create(
	Logo,
	TweenInfo.new(0.3),
	{TextColor3 = Color3.new(1, 1, 1)}
):Play()

--------------------------------------------------
-- FADE OUT + LIMPIEZA
--------------------------------------------------

task.wait(2)

local fadeOut = TweenService:Create(Logo, TweenInfo.new(0.8), {TextTransparency = 1})
fadeOut:Play()
TweenService:Create(Icon, TweenInfo.new(0.8), {ImageTransparency = 1}):Play()
TweenService:Create(Blur, TweenInfo.new(1), {Size = 0}):Play()

task.wait(1)

Gui:Destroy()
Blur:Destroy()
Sound:Destroy()
