-- ================== CONFIG ==================
local KEEP_HIDDEN_AFTER = false -- true = 注入结束后仍然隐藏其他UI
local MY_GUI_NAME = "RyzenInjectorUI"
-- ===========================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 覆盖旧的管理器（防重复监听）
if playerGui:FindFirstChild("__RyzenUIManager") then
	playerGui.__RyzenUIManager:Destroy()
end

-- 管理器标记
local manager = Instance.new("Folder")
manager.Name = "__RyzenUIManager"
manager.Parent = playerGui

-- 记录被隐藏的 UI（用于恢复）
local hidden = {}

-- 判断是否应忽略（白名单）
local function isWhitelisted(gui)
	if not gui:IsA("ScreenGui") then return true end
	if gui.Name == MY_GUI_NAME then return true end
	if gui:IsDescendantOf(CoreGui) then return true end
	return false
end

-- 隐藏一个 GUI（安全）
local function hideGui(gui)
	if hidden[gui] then return end
	if gui.Enabled then
		hidden[gui] = true
		gui.Enabled = false
	end
end

-- 扫描并隐藏当前已有的
for _, gui in ipairs(playerGui:GetChildren()) do
	if not isWhitelisted(gui) then
		hideGui(gui)
	end
end

-- 实时拦截新建的 UI
local conn
conn = playerGui.ChildAdded:Connect(function(gui)
	task.defer(function()
		if not manager.Parent then return end
		if not isWhitelisted(gui) then
			hideGui(gui)
		end
	end)
end)

-- ========== 这里显示你的注入 UI ==========
-- （把你之前做好的橙色发光注入 UI 放这里创建）
-- 示例停留 6 秒：
task.wait(6)
-- ========================================

-- 停止拦截
if conn then conn:Disconnect() end
manager:Destroy()

-- 恢复（可选）
if not KEEP_HIDDEN_AFTER then
	for gui, _ in pairs(hidden) do
		if gui and gui.Parent then
			gui.Enabled = true
		end
	end
end
