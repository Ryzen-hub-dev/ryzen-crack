local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeExecutorGui"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false

-- Create main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- Add shadow effect
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(50, 50, 50)
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = frame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Fake Executor - Script Capture"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = frame

-- URL input textbox
local urlInput = Instance.new("TextBox")
urlInput.Size = UDim2.new(0.9, 0, 0, 30)
urlInput.Position = UDim2.new(0.05, 0, 0, 50)
urlInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
urlInput.TextColor3 = Color3.fromRGB(255, 255, 255)
urlInput.PlaceholderText = "Enter script URL here"
urlInput.TextSize = 16
urlInput.Font = Enum.Font.SourceSans
urlInput.TextXAlignment = Enum.TextXAlignment.Left
urlInput.ClearTextOnFocus = false
urlInput.Parent = frame

local urlInputCorner = Instance.new("UICorner")
urlInputCorner.CornerRadius = UDim.new(0, 5)
urlInputCorner.Parent = urlInput

-- Load button
local loadButton = Instance.new("TextButton")
loadButton.Size = UDim2.new(0.9, 0, 0, 30)
loadButton.Position = UDim2.new(0.05, 0, 0, 90)
loadButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loadButton.Text = "Load & Capture (Fake Execute)"
loadButton.TextSize = 16
loadButton.Font = Enum.Font.SourceSansBold
loadButton.Parent = frame

local loadButtonCorner = Instance.new("UICorner")
loadButtonCorner.CornerRadius = UDim.new(0, 5)
loadButtonCorner.Parent = loadButton

-- File name label
local fileNameLabel = Instance.new("TextLabel")
fileNameLabel.Size = UDim2.new(0.9, 0, 0, 20)
fileNameLabel.Position = UDim2.new(0.05, 0, 0, 130)
fileNameLabel.BackgroundTransparency = 1
fileNameLabel.Text = "Captured File: None"
fileNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fileNameLabel.TextSize = 14
fileNameLabel.Font = Enum.Font.SourceSans
fileNameLabel.TextXAlignment = Enum.TextXAlignment.Left
fileNameLabel.Parent = frame

-- Content textbox (readonly)
local contentBox = Instance.new("TextBox")
contentBox.Size = UDim2.new(0.9, 0, 0, 80)
contentBox.Position = UDim2.new(0.05, 0, 0, 160)
contentBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
contentBox.TextColor3 = Color3.fromRGB(255, 255, 255)
contentBox.PlaceholderText = "Script content will appear here"
contentBox.TextSize = 14
contentBox.Font = Enum.Font.SourceSans
contentBox.TextXAlignment = Enum.TextXAlignment.Left
contentBox.TextYAlignment = Enum.TextYAlignment.Top
contentBox.MultiLine = true
contentBox.ClearTextOnFocus = false
contentBox.TextEditable = false
contentBox.Parent = frame

local contentBoxCorner = Instance.new("UICorner")
contentBoxCorner.CornerRadius = UDim.new(0, 5)
contentBoxCorner.Parent = contentBox

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.9, 0, 0, 30)
copyButton.Position = UDim2.new(0.05, 0, 0, 250)
copyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Text = "Copy Content"
copyButton.TextSize = 16
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = frame

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 5)
copyButtonCorner.Parent = copyButton

-- Load button functionality
loadButton.MouseButton1Click:Connect(function()
    local url = urlInput.Text
    if url == "" then
        warn("Please enter a URL")
        fileNameLabel.Text = "Captured File: None"
        contentBox.Text = "Error: No URL provided"
        return
    end

    -- Fetch script content
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        warn("Failed to fetch script: " .. content)
        fileNameLabel.Text = "Captured File: None"
        contentBox.Text = "Error: Failed to fetch script"
        return
    end

    -- Extract file name from URL
    local fileName = url:match("([^/]+)$") or "Unknown.lua"
    fileNameLabel.Text = "Captured File: " .. fileName
    contentBox.Text = content

    -- Log capture (can be extended to save to table or file)
    print("Captured script: " .. fileName .. "\nContent length: " .. #content .. " characters")
end)

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    if contentBox.Text ~= "" and contentBox.Text ~= "Error: No URL provided" and contentBox.Text ~= "Error: Failed to fetch script" then
        pcall(function()
            setclipboard(contentBox.Text)
            print("Content copied to clipboard!")
        end)
    else
        warn("No valid content to copy")
    end
end)

-- Notify user
print("Fake Executor GUI loaded. Enter a URL and click 'Load & Capture' to capture script content.")
