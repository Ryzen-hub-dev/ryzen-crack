-- Roblox YBA Auto Farm Script with GUI for Stand/Skin Farming
-- This script is inspired by common YBA scripts and enhanced with a custom GUI for selecting stands and options.
-- It auto farms arrows and roka if missing, with a 1.3 second delay between picks to avoid detection.
-- Note: This requires a Roblox executor that supports teleportation and proximity prompts (e.g., Synapse, Krnl).
-- Item spawns are dynamic in YBA, so the script scans workspace for items. Add spawn positions if needed for efficiency.
-- Stand and skin checking assumes standard YBA data paths; adjust if game updates.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Backpack = LocalPlayer.Backpack
local Data = LocalPlayer:WaitForChild("Data")
local Stand = Data:WaitForChild("Stand")
local Skin = Data:WaitForChild("Skin")  -- Assuming Skin Value exists; in some games it's PlayerGui.Main.SkinName or similar.

-- Sample spawn positions for efficiency (add more real positions from YBA map, e.g., park, streets).
local SpawnPositions = {
    Vector3.new( -50, 5, -50 ),  -- Example position 1
    Vector3.new( 0, 5, 0 ),       -- Example position 2
    Vector3.new( 50, 5, 50 ),     -- Example position 3
    -- Add more Vector3 positions here by printing CFrame in-game or from other scripts.
}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YBAFarmGUI"
ScreenGui.Parent = game.CoreGui  -- Use CoreGui for exploit visibility.

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "YBA Auto Farm Script"
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

local StandInput = Instance.new("TextBox")
StandInput.Size = UDim2.new(1, 0, 0, 30)
StandInput.Position = UDim2.new(0, 0, 0, 30)
StandInput.Text = "Enter Stand Name (e.g., Silver Chariot)"
StandInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
StandInput.Parent = MainFrame

local FarmTypeLabel = Instance.new("TextLabel")
FarmTypeLabel.Size = UDim2.new(1, 0, 0, 30)
FarmTypeLabel.Position = UDim2.new(0, 0, 0, 60)
FarmTypeLabel.Text = "Farm Type:"
FarmTypeLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FarmTypeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmTypeLabel.Parent = MainFrame

local StandButton = Instance.new("TextButton")
StandButton.Size = UDim2.new(0.5, 0, 0, 30)
StandButton.Position = UDim2.new(0, 0, 0, 90)
StandButton.Text = "Farm Stand"
StandButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
StandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StandButton.Parent = MainFrame

local SkinButton = Instance.new("TextButton")
SkinButton.Size = UDim2.new(0.5, 0, 0, 30)
SkinButton.Position = UDim2.new(0.5, 0, 0, 90)
SkinButton.Text = "Farm Skin"
SkinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SkinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SkinButton.Parent = MainFrame

local OptionsLabel = Instance.new("TextLabel")
OptionsLabel.Size = UDim2.new(1, 0, 0, 30)
OptionsLabel.Position = UDim2.new(0, 0, 0, 120)
OptionsLabel.Text = "Skin Options:"
OptionsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OptionsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OptionsLabel.Parent = MainFrame

local ShinyToggle = Instance.new("TextButton")
ShinyToggle.Size = UDim2.new(0.5, 0, 0, 30)
ShinyToggle.Position = UDim2.new(0, 0, 0, 150)
ShinyToggle.Text = "Shiny: Off"
ShinyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ShinyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ShinyToggle.Parent = MainFrame

local LimitedToggle = Instance.new("TextButton")
LimitedToggle.Size = UDim2.new(0.5, 0, 0, 30)
LimitedToggle.Position = UDim2.new(0.5, 0, 0, 150)
LimitedToggle.Text = "Limited: Off"
LimitedToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LimitedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
LimitedToggle.Parent = MainFrame

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(1, 0, 0, 40)
StartButton.Position = UDim2.new(0, 0, 0, 300)
StartButton.Text = "Start Farm"
StartButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Parent = MainFrame

-- Variables
local targetStand = "Silver Chariot"
local farmType = "stand"  -- "stand" or "skin"
local wantShiny = false
local wantLimited = false
local isRunning = false

-- GUI Events
StandInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        targetStand = StandInput.Text
    end
end)

StandButton.MouseButton1Click:Connect(function()
    farmType = "stand"
    StandButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    SkinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

SkinButton.MouseButton1Click:Connect(function()
    farmType = "skin"
    SkinButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    StandButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

ShinyToggle.MouseButton1Click:Connect(function()
    wantShiny = not wantShiny
    ShinyToggle.Text = "Shiny: " .. (wantShiny and "On" or "Off")
    ShinyToggle.BackgroundColor3 = wantShiny and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(50, 50, 50)
end)

LimitedToggle.MouseButton1Click:Connect(function()
    wantLimited = not wantLimited
    LimitedToggle.Text = "Limited: " .. (wantLimited and "On" or "Off")
    LimitedToggle.BackgroundColor3 = wantLimited and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(50, 50, 50)
end)

StartButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    StartButton.Text = isRunning and "Stop Farm" or "Start Farm"
    StartButton.BackgroundColor3 = isRunning and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(0, 150, 0)
end)

-- Function to collect specific item (arrows or roka)
local function CollectItem(itemName)
    -- Scan workspace for the item
    for _, item in pairs(Workspace:GetChildren()) do
        if item.Name == itemName and (item:IsA("Part") or item:IsA("Model")) then
            Character.HumanoidRootPart.CFrame = item.CFrame * CFrame.new(0, 3, 0)  -- TP above to avoid clipping
            wait(0.5)
            for _, prompt in pairs(item:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    fireproximityprompt(prompt, 1, false)  -- Fire the prompt to pick up
                end
            end
            wait(1.3)  -- Delay as requested
            return true  -- Found and picked
        end
    end
    
    -- If not found, TP to spawn positions to search
    for _, pos in pairs(SpawnPositions) do
        Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        wait(1.3)
    end
    return false
end

-- Function to use item (arrow or roka)
local function UseItem(itemName)
    local item = Backpack:FindFirstChild(itemName) or Character:FindFirstChild(itemName)
    if item then
        if item.Parent == Backpack then
            item.Parent = Character  -- Equip if in backpack
        end
        item:Activate()
        wait(5)  -- Wait for use animation/effect
        return true
    end
    return false
end

-- Main Farm Loop
spawn(function()
    while true do
        wait(0.5)
        if not isRunning then continue end
        
        -- Check and farm arrow if missing
        if not (Backpack:FindFirstChild("Mysterious Arrow") or Character:FindFirstChild("Mysterious Arrow")) then
            CollectItem("Mysterious Arrow")
        end
        
        -- Use arrow to get stand
        UseItem("Mysterious Arrow")
        
        -- Check obtained stand/skin
        wait(2)  -- Delay to update data
        local currentStand = Stand.Value
        local currentSkin = Skin.Value  -- Assume "None" for normal, "Shiny" or specific names for others
        
        local keepStand = false
        if farmType == "stand" then
            if currentStand == targetStand then
                keepStand = true
            end
        elseif farmType == "skin" then
            if currentStand == targetStand and currentSkin ~= "None" then
                if (wantShiny and string.find(currentSkin:lower(), "shiny")) or (wantLimited and string.find(currentSkin:lower(), "limited")) then
                    keepStand = true
                end
            end
        end
        
        if not keepStand then
            -- Farm roka if missing and reset
            if not (Backpack:FindFirstChild("Rokakaka") or Character:FindFirstChild("Rokakaka")) then
                CollectItem("Rokakaka")
            end
            UseItem("Rokakaka")
        else
            -- Got desired, stop or notify
            print("Desired " .. farmType .. " obtained: " .. currentStand .. " with skin " .. currentSkin)
            -- isRunning = false  -- Uncomment to stop on success
        end
    end
end)

-- Respawn handler to keep character reference updated
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)
