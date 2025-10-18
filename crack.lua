-- Embedded YBA Auto Farm Script with Kavo UI
-- Features: Stand selection, mode (Stand/Skin), auto collect arrow/roka every 1s, no external dependencies.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Embedded Kavo UI (simplified version)
local Library = {
    CreateLib = function(name, theme)
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = game.CoreGui
        ScreenGui.Name = "KavoUI"
        ScreenGui.ResetOnSpawn = false

        local Main = Instance.new("Frame")
        Main.Parent = ScreenGui
        Main.Size = UDim2.new(0, 300, 0, 400)
        Main.Position = UDim2.new(0.5, -150, 0.5, -200)
        Main.BackgroundColor3 = Color3.fromRGB(36, 37, 43)

        local TabHolder = Instance.new("Frame")
        TabHolder.Parent = Main
        TabHolder.Size = UDim2.new(0, 80, 0, 400)
        TabHolder.BackgroundColor3 = Color3.fromRGB(28, 29, 34)

        local PageHolder = Instance.new("Frame")
        PageHolder.Parent = Main
        PageHolder.Size = UDim2.new(0, 220, 0, 400)
        PageHolder.Position = UDim2.new(0, 80, 0, 0)
        PageHolder.BackgroundTransparency = 1

        local function CreateTab(name)
            local TabButton = Instance.new("TextButton")
            TabButton.Parent = TabHolder
            TabButton.Size = UDim2.new(0, 80, 0, 40)
            TabButton.Text = name
            TabButton.BackgroundColor3 = Color3.fromRGB(74, 99, 135)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)

            local Page = Instance.new("Frame")
            Page.Parent = PageHolder
            Page.Size = UDim2.new(1, 0, 1, 0)
            Page.BackgroundTransparency = 1
            Page.Visible = false

            if not PageHolder:FindFirstChild("CurrentPage") then
                Page.Visible = true
                Page.Name = "CurrentPage"
            end

            TabButton.MouseButton1Click:Connect(function()
                for _, v in pairs(PageHolder:GetChildren()) do
                    v.Visible = false
                end
                Page.Visible = true
                Page.Name = "CurrentPage"
            end)

            return {
                NewSection = function(sectionName)
                    local Section = Instance.new("Frame")
                    Section.Parent = Page
                    Section.Size = UDim2.new(1, -20, 0, 0)
                    Section.Position = UDim2.new(0, 10, 0, 10)
                    Section.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
                    Section.BorderSizePixel = 0

                    local function UpdateSize()
                        local totalHeight = 0
                        for _, child in pairs(Section:GetChildren()) do
                            if child:IsA("GuiObject") then
                                totalHeight = totalHeight + child.Size.Y.Offset + 5
                            end
                        end
                        Section.Size = UDim2.new(1, -20, 0, totalHeight + 10)
                    end

                    return {
                        NewDropdown = function(dropdownName, options, callback)
                            local Dropdown = Instance.new("TextButton")
                            Dropdown.Parent = Section
                            Dropdown.Size = UDim2.new(1, -20, 0, 30)
                            Dropdown.Text = dropdownName .. ": None"
                            Dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                            Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)

                            local DropdownList = Instance.new("Frame")
                            DropdownList.Parent = Section
                            DropdownList.Size = UDim2.new(1, -20, 0, 0)
                            DropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                            DropdownList.Visible = false
                            DropdownList.Position = UDim2.new(0, 0, 0, 35)

                            local ListLayout = Instance.new("UIListLayout")
                            ListLayout.Parent = DropdownList
                            ListLayout.Padding = UDim.new(0, 5)

                            for _, option in pairs(options) do
                                local Option = Instance.new("TextButton")
                                Option.Parent = DropdownList
                                Option.Size = UDim2.new(1, -10, 0, 25)
                                Option.Text = option
                                Option.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                                Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                                Option.MouseButton1Click:Connect(function()
                                    Dropdown.Text = dropdownName .. ": " .. option
                                    callback(option)
                                    DropdownList.Visible = false
                                end)
                            end

                            Dropdown.MouseButton1Click:Connect(function()
                                DropdownList.Visible = not DropdownList.Visible
                                if DropdownList.Visible then
                                    DropdownList.Size = UDim2.new(1, -20, 0, #options * 30)
                                end
                            end)

                            UpdateSize()
                            return {}
                        end,

                        NewToggle = function(toggleName, callback)
                            local Toggle = Instance.new("TextButton")
                            Toggle.Parent = Section
                            Toggle.Size = UDim2.new(1, -20, 0, 30)
                            Toggle.Text = toggleName .. ": Off"
                            Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)

                            Toggle.MouseButton1Click:Connect(function()
                                local state = Toggle.Text:match("On") == nil
                                Toggle.Text = toggleName .. ": " .. (state and "On" or "Off")
                                callback(state)
                            end)

                            UpdateSize()
                            return {}
                        end,

                        NewButton = function(buttonName, callback)
                            local Button = Instance.new("TextButton")
                            Button.Parent = Section
                            Button.Size = UDim2.new(1, -20, 0, 30)
                            Button.Text = buttonName
                            Button.BackgroundColor3 = Color3.fromRGB(74, 99, 135)
                            Button.TextColor3 = Color3.fromRGB(255, 255, 255)

                            Button.MouseButton1Click:Connect(callback)

                            UpdateSize()
                            return {}
                        end
                    }
                end
            }
        end
    }
}

-- Initialize UI
local Window = Library.CreateLib("YBA Stand/Skin Farm", "Ocean")
local Tab = Window:NewTab("Farm Settings")
local Section = Tab:NewSection("Configuration")

-- Variables
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Backpack = LocalPlayer.Backpack
local isFarming = false
local targetStand = "Star Platinum"
local farmMode = "Stand"
local wantShiny = false
local wantLimited = false

-- Stand list
local AllStands = {
    "Star Platinum", "The World", "Crazy Diamond", "Silver Chariot", "The Hand", "Gold Experience",
    "Sticky Fingers", "Hermit Purple", "Magician's Red", "Hierophant Green", "Beach Boy",
    "Anubis", "Cream", "Killer Queen", "King Crimson", "Tusk Act 2", "White Album",
    "Purple Haze", "Soft & Wet", "Stone Free", "Aerosmith", "Sex Pistols", "Scary Monsters",
    "Red Hot Chili Pepper", "Tusk Act 3", "Dirty Deeds Done Dirt Cheap", "Whitesnake",
    "C-Moon", "Tusk Act 4", "The World (AU)", "Made in Heaven", "Gold Experience Requiem",
    "King Crimson Requiem", "Silver Chariot Requiem", "Star Platinum: The World", "Chariot Requiem",
    "D4C Love Train", "The World Over Heaven", "Soft & Wet: Go Beyond", "Killer Queen: Bites the Dust"
}

-- Spawn positions
local SpawnPositions = {
    CFrame.new(-503, 19, -341), -- Park trash
    CFrame.new(-572, 19, -353), -- Fountain
    CFrame.new(-641, 19, -378), -- Train station
    CFrame.new(-432, 19, -285), -- Pizza shop
    CFrame.new(-695, 19, -413), -- Arcade
    CFrame.new(-366, 19, -226), -- Main street
    CFrame.new(-760, 19, -468), -- Bar
    CFrame.new(-294, 19, -167), -- Parking lot
    CFrame.new(-549, 19, -397), -- Stairs
    CFrame.new(-618, 19, -317)  -- NPC area
}

-- GUI Setup
Section:NewDropdown("Select Stand", AllStands, function(selected)
    targetStand = selected:lower()
    print("Selected stand: " .. targetStand)
end)

Section:NewDropdown("Farm Mode", {"Stand", "Skin"}, function(selected)
    farmMode = selected
    print("Farm mode: " .. farmMode)
end)

Section:NewToggle("Shiny Skin", function(state)
    wantShiny = state
    print("Shiny skin: " .. tostring(wantShiny))
end)

Section:NewToggle("Limited Skin", function(state)
    wantLimited = state
    print("Limited skin: " .. tostring(wantLimited))
end)

Section:NewButton("Start/Stop Farm", function()
    isFarming = not isFarming
    print("Farming: " .. tostring(isFarming))
end)

-- Collect item function
local function CollectItem(itemName)
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == itemName and (obj:IsA("Part") or obj:IsA("Model")) then
            HumanoidRootPart.CFrame = obj.CFrame * CFrame.new(0, 5, 0)
            task.wait(0.3)
            local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt, 1)
                task.wait(1)  -- 1s delay as requested
                return true
            end
        end
    end
    for _, pos in pairs(SpawnPositions) do
        HumanoidRootPart.CFrame = pos
        task.wait(1)  -- 1s delay between teleports
    end
    return false
end

-- Use item function
local function UseItem(itemName)
    local item = Backpack:FindFirstChild(itemName) or Character:FindFirstChild(itemName)
    if item then
        if item.Parent == Backpack then
            Character.Humanoid:EquipTool(item)
        end
        item:Activate()
        task.wait(4)
        return true
    end
    return false
end

-- Get current stand and skin
local function GetCurrentStandInfo()
    local success, stand, skin = pcall(function()
        local data = LocalPlayer:FindFirstChild("Data") or LocalPlayer.PlayerGui.Main:FindFirstChild("Data")
        return data:FindFirstChild("Stand").Value:lower(), (data:FindFirstChild("Skin") or data:FindFirstChild("SkinName")).Value:lower()
    end)
    return success and stand or "", success and skin or "none"
end

-- Farm loop
spawn(function()
    while true do
        task.wait(0.5)
        if not isFarming then continue end
        
        -- Auto collect arrow if missing
        if not (Backpack:FindFirstChild("Mysterious Arrow") or Character:FindFirstChild("Mysterious Arrow")) then
            print("Searching for Arrow...")
            CollectItem("Mysterious Arrow")
        end
        
        -- Use arrow
        UseItem("Mysterious Arrow")
        task.wait(3)
        
        -- Check result
        local currentStand, currentSkin = GetCurrentStandInfo()
        local keep = false
        if farmMode == "Stand" then
            if currentStand == targetStand then
                keep = true
            end
        else
            if currentStand == targetStand then
                if (wantShiny and currentSkin:find("shiny")) or (wantLimited and currentSkin:find("limited")) then
                    keep = true
                end
            end
        end
        
        if not keep then
            -- Auto collect roka if missing
            if not (Backpack:FindFirstChild("Rokakaka") or Character:FindFirstChild("Rokakaka")) then
                print("Searching for Rokakaka...")
                CollectItem("Rokakaka")
            end
            UseItem("Rokakaka")
        else
            print("Success! Obtained: " .. currentStand .. " with skin " .. currentSkin)
            isFarming = false
        end
    end
end)

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Backpack = LocalPlayer.Backpack
end)
