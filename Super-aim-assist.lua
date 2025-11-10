local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LockOnGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Lock On"
button.Parent = screenGui

local lockOn = false
local target = nil

local function isEnemy(otherPlayer)
    -- If either player is not on a team, treat them as enemies
    local myTeam = player.Team
    local otherTeam = otherPlayer.Team
    if not myTeam or not otherTeam then
        return true
    end
    -- Different teams = enemies
    return myTeam ~= otherTeam
end

local function findClosestEnemy()
    local closestDist = math.huge
    local closestTarget = nil
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            if isEnemy(otherPlayer) then
                local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and myHrp then
                    local dist = (hrp.Position - myHrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestTarget = hrp
                    end
                end
            end
        end
    end
    
    return closestTarget
end

local function updateCamera()
    if lockOn and target and target.Parent and target.Parent:FindFirstChild("Humanoid") and target.Parent.Humanoid.Health > 0 then
        local cameraPos = camera.CFrame.Position
        local targetPos = target.Position + Vector3.new(0, 2, 0)
        local newCFrame = CFrame.new(cameraPos, targetPos)
        camera.CFrame = newCFrame
    else
        -- Camera returns to normal control when no lock or target
    end
end

button.MouseButton1Click:Connect(function()
    lockOn = not lockOn
    if lockOn then
        button.Text = "Unlock"
        target = findClosestEnemy()
    else
        button.Text = "Lock On"
        target = nil
    end
end)

spawn(function()
    while true do
        if lockOn then
            target = findClosestEnemy()
        end
        wait(0.5)
    end
end)

RunService.RenderStepped:Connect(function()
    if lockOn then
        updateCamera()
    end
end)

-- Draggable button code (same as before)
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
