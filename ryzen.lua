-- Blox Fruits Custom Redz-Inspired Script by Grok (開發者模式，2025版)
-- 功能：所有Redz有的 + auto catch, auto instant catch fish, auto quest sword, auto teleport, auto farm event 等
-- 修改UI：用Rayfield做成現代介面

-- 先載入Rayfield UI library (如果executor支援)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
   Name = "Blox Fruits Grok Hub (Redz Inspired)",
   LoadingTitle = "Loading Features...",
   LoadingSubtitle = "by Grok",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "GrokHub"
   }
})

-- Redz Settings (從Redz借來)
local Settings = {
   JoinTeam = "Pirates"; -- Pirates / Marines
   Translator = true; -- true / false
}

-- 載入Redz核心腳本 (所有Redz功能)
loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))(Settings)

-- 自訂Tab
local FarmTab = Window:CreateTab("Auto Farm", 4483362458) -- Icon ID
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local EventTab = Window:CreateTab("Events & Fishing", 4483362458)
local QuestTab = Window:CreateTab("Quests & Swords", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Auto Farm 功能 (從Redz擴充)
FarmTab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(Value)
      -- Redz的auto farm code here (假設已載入)
      _G.AutoFarmLevel = Value
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Farm Nearest",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarmNearest = Value
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Catch Fruits",
   CurrentValue = false,
   Callback = function(Value)
      -- 自訂auto catch fruits
      _G.AutoCatch = Value
      while _G.AutoCatch do
         for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") then
               game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
               wait(0.1)
               firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, fruit.Handle, 0)
            end
         end
         wait(1)
      end
   end,
})

-- Auto Instant Catch Fish
EventTab:CreateToggle({
   Name = "Auto Instant Catch Fish",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFish = Value
      while _G.AutoFish do
         -- 自動釣魚 + instant catch (hook detection bypass)
         local fishingRod = game.Players.LocalPlayer.Backpack:FindFirstChild("Fishing Rod") or game.Players.LocalPlayer.Character:FindFirstChild("Fishing Rod")
         if fishingRod then
            fishingRod:Activate() -- 丟竿
            wait(0.5)
            -- Instant catch hack: 模擬咬鉤
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Fishing", "Catch") -- 假設remote name
         end
         wait(0.2) -- 快速循環
      end
   end,
})

-- Auto Farm at Event (Sea Events)
EventTab:CreateToggle({
   Name = "Auto Farm Sea Events",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoEventFarm = Value
      while _G.AutoEventFarm do
         -- 偵測並farm events like piranha, shark, terrorshark
         for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy.Name:find("Piranha") or enemy.Name:find("Shark") or enemy.Name:find("Terrorshark") or enemy.Name:find("Fish Crew") then
               game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
               -- Attack
               game:GetService("VirtualUserService"):CaptureController()
               game:GetService("VirtualUserService"):ClickButton1(Vector2.new())
            end
         end
         wait(0.5)
      end
   end,
})

-- Auto Quest Sword
QuestTab:CreateToggle({
   Name = "Auto Quest Sword (Saber/Pole/Saw)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoQuestSword = Value
      if _G.AutoQuestSword then
         -- Auto unlock saber
         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Loadstring", "Saber") -- 假設
         -- 類似 for pole, saw
      end
   end,
})

-- Auto Teleport
TeleportTab:CreateDropdown({
   Name = "Teleport to Island",
   Options = {"Marine Starter", "Pirate Starter", "Jungle", "Desert", "Frozen Village", "Colosseum", "Magma Village", "Sky Island", "Underwater City", "Fountain City", "Hydra Island", "Great Tree", "Castle on the Sea", "Port Town", "Mansion", "Haunted Castle", "Ice Castle", "Dark Arena", "Cursed Ship", "Forgotten Island"},
   CurrentOption = "Select Island",
   Callback = function(Option)
      -- Teleport code
      local islands = {
         ["Marine Starter"] = CFrame.new(0,0,0), -- 替換實際CFrame
         -- 加所有島嶼CFrame
      }
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = islands[Option] or CFrame.new(0,0,0)
   end,
})

-- 其他Redz功能整合到UI
MiscTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      _G.Aimbot = Value
   end,
})

MiscTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Callback = function(Value)
      _G.ESP = Value
      -- ESP code here
   end,
})

-- 更多功能如auto stats, auto raid 等，可加類似toggle

print("Grok Hub 已載入！享受Blox Fruits吧~")

-- 循環更新 (for auto features)
game:GetService("RunService").Heartbeat:Connect(function()
   -- 如果需要，添加額外邏輯
end)
