-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🔥 强制覆盖旧 UI
for _, v in ipairs(playerGui:GetChildren()) do
	if v.Name == "RyzenInjectorUI" then
		v:Destroy()
	end
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "RyzenInjectorUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 440, 0, 130)
frame.Position = UDim2.new(1, -460, 1, -160)
frame.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
frame.BackgroundTransparency = 1
frame.Parent = gui

-- Rounded
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = frame

-- Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 0))
})
gradient.Rotation = 90
gradient.Parent = frame

-- Glow Stroke
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 170, 60)
stroke.Thickness = 3
stroke.Transparency = 1
stroke.Parent = frame

-- Text
local text = Instance.new("TextLabel")
text.Size = UDim2.new(1, -24, 1, -24)
text.Position = UDim2.new(0, 12, 0, 12)
text.BackgroundTransparency = 1
text.TextWrapped = true
text.TextScaled = true
text.Font = Enum.Font.GothamBold
text.TextXAlignment = Enum.TextXAlignment.Left
text.TextYAlignment = Enum.TextYAlignment.Center
text.TextColor3 = Color3.fromRGB(255, 255, 255)
text.TextTransparency = 1
text.Text = "⚡ Congratulations,\nYou have successfully injected\nusing Ryzen Executor"
text.Parent = frame

-- 🔊 Inject Success Sound（避免叠音）
for _, s in ipairs(SoundService:GetChildren()) do
	if s.Name == "RyzenInjectSound" then
		s:Destroy()
	end
end

local sound = Instance.new("Sound")
sound.Name = "RyzenInjectSound"
sound.SoundId = "rbxassetid://9118826049"
sound.Volume = 1
sound.Parent = SoundService
sound:Play()

-- Fade In
TweenService:Create(frame, TweenInfo.new(0.45), {
	BackgroundTransparency = 0
}):Play()

TweenService:Create(text, TweenInfo.new(0.45), {
	TextTransparency = 0
}):Play()

TweenService:Create(stroke, TweenInfo.new(0.6), {
	Transparency = 0
}):Play()

-- Glow Pulse
TweenService:Create(
	stroke,
	TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{ Thickness = 6 }
):Play()

-- ⏱ 停留 6 秒
task.wait(6)

-- ⬇️ Drop & Fade
TweenService:Create(frame, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
	Position = UDim2.new(1, -460, 1, 260),
	BackgroundTransparency = 1
}):Play()

TweenService:Create(text, TweenInfo.new(0.5), {
	TextTransparency = 1
}):Play()

TweenService:Create(stroke, TweenInfo.new(0.5), {
	Transparency = 1
}):Play()

task.wait(1)
gui:Destroy()
