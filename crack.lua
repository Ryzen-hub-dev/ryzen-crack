local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeExecutorGui"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false

-- Create main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 360)
frame.Position = UDim2.new(0.5, -225, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

-- Add shadow effect
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(50, 50, 50)
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = frame

-- Draggable header
local dragHeader = Instance.new("Frame")
dragHeader.Size = UDim2.new(1, 0, 0, 40)
dragHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
dragHeader.BorderSizePixel = 0
dragHeader.Parent = frame

local dragHeaderCorner = Instance.new("UICorner")
dragHeaderCorner.CornerRadius = UDim.new(0, 12)
dragHeaderCorner.Parent = dragHeader

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Script Capture Executor"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = dragHeader

-- URL input textbox
local urlInput = Instance.new("TextBox")
urlInput.Size = UDim2.new(0.92, 0, 0, 40)
urlInput.Position = UDim2.new(0.04, 0, 0, 60)
urlInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
urlInput.TextColor3 = Color3.fromRGB(255, 255, 255)
urlInput.PlaceholderText = "Enter script URL (e.g., https://raw.githubusercontent.com/...)"
urlInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
urlInput.TextSize = 16
urlInput.Font = Enum.Font.Gotham
urlInput.TextXAlignment = Enum.TextXAlignment.Left
urlInput.ClearTextOnFocus = false
urlInput.Parent = frame

local urlInputCorner = Instance.new("UICorner")
urlInputCorner.CornerRadius = UDim.new(0, 8)
urlInputCorner.Parent = urlInput

local urlInputStroke = Instance.new("UIStroke")
urlInputStroke.Thickness = 1
urlInputStroke.Color = Color3.fromRGB(80, 80, 80)
urlInputStroke.Parent = urlInput

-- Execute button
local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0.92, 0, 0, 40)
executeButton.Position = UDim2.new(0.04, 0, 0, 110)
executeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.Text = "Execute (Capture)"
executeButton.TextSize = 18
executeButton.Font = Enum.Font.GothamBold
executeButton.Parent = frame

local executeButtonCorner = Instance.new("UICorner")
executeButtonCorner.CornerRadius = UDim.new(0, 8)
executeButtonCorner.Parent = executeButton

-- Button hover effect
executeButton.MouseEnter:Connect(function()
    executeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)
executeButton.MouseLeave:Connect(function()
    executeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)

-- File name label
local fileNameLabel = Instance.new("TextLabel")
fileNameLabel.Size = UDim2.new(0.92, 0, 0, 25)
fileNameLabel.Position = UDim2.new(0.04, 0, 0, 160)
fileNameLabel.BackgroundTransparency = 1
fileNameLabel.Text = "Captured File: None"
fileNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fileNameLabel.TextSize = 16
fileNameLabel.Font = Enum.Font.Gotham
fileNameLabel.TextXAlignment = Enum.TextXAlignment.Left
fileNameLabel.Parent = frame

-- Content textbox (readonly)
local contentBox = Instance.new("TextBox")
contentBox.Size = UDim2.new(0.92, 0, 0, 120)
contentBox.Position = UDim2.new(0.04, 0, 0, 195)
contentBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentBox.TextColor3 = Color3.fromRGB(255, 255, 255)
contentBox.PlaceholderText = "Captured script content will appear here"
contentBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
contentBox.TextSize = 14
contentBox.Font = Enum.Font.Gotham
contentBox.TextXAlignment = Enum.TextXAlignment.Left
contentBox.TextYAlignment = Enum.TextYAlignment.Top
contentBox.MultiLine = true
contentBox.ClearTextOnFocus = false
contentBox.TextEditable = false
contentBox.Parent = frame

local contentBoxCorner = Instance.new("UICorner")
contentBoxCorner.CornerRadius = UDim.new(0, 8)
contentBoxCorner.Parent = contentBox

local contentBoxStroke = Instance.new("UIStroke")
contentBoxStroke.Thickness = 1
contentBoxStroke.Color = Color3.fromRGB(80, 80, 80)
contentBoxStroke.Parent = contentBox

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.92, 0, 0, 40)
copyButton.Position = UDim2.new(0.04, 0, 0, 315)
copyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Text = "Copy Content"
copyButton.TextSize = 18
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = frame

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 8)
copyButtonCorner.Parent = copyButton

-- Copy button hover effect
copyButton.MouseEnter:Connect(function()
    copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)
copyButton.MouseLeave:Connect(function()
    copyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)

-- Dragging functionality
local dragging, dragInput, dragStart, startPos
dragHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragHeader.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Table to store captured scripts
local capturedScripts = {}

-- Execute button functionality
executeButton.MouseButton1Click:Connect(function()
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

    -- Store captured script
    table.insert(capturedScripts, {
        fileName = fileName,
        content = content,
        timestamp = os.date("%Y-%m-%d %H:%M:%S")
    })

    -- Log capture
    print("Captured script: " .. fileName .. "\nContent length: " .. #content .. " characters")
    print("Timestamp: " .. capturedScripts[#capturedScripts].timestamp)
end)

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    if contentBox.Text ~= "" and contentBox.Text ~= "Error: No URL provided" and contentBox.Text ~= "Error: Failed to fetch script" then
        local success, err = pcall(function()
            setclipboard(contentBox.Text)
        end)
        if success then
            print("Content copied to clipboard!")
        else
            warn("Failed to copy content: " .. err)
        end
    else
        warn("No valid content to copy")
    end
end)

-- Notify user
print("Fake Executor GUI loaded. Drag the top bar to move. Enter a URL and click 'Execute (Capture)' to capture script content.")
