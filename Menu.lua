-- VacTec Menu - Local Script
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VacTecGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Variables for features
local flyEnabled = false
local noclipEnabled = false
local espEnabled = false
local showTeam = false
local baseSpeed = 16
local flying = nil

-- Password Screen
local passwordFrame = Instance.new("Frame")
passwordFrame.Name = "PasswordFrame"
passwordFrame.Size = UDim2.new(0, 300, 0, 200)
passwordFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
passwordFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
passwordFrame.BorderSizePixel = 2
passwordFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
passwordFrame.Parent = screenGui

local passwordTitle = Instance.new("TextLabel")
passwordTitle.Size = UDim2.new(1, 0, 0, 40)
passwordTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
passwordTitle.Text = "VacTec Access"
passwordTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
passwordTitle.TextSize = 20
passwordTitle.Font = Enum.Font.GothamBold
passwordTitle.Parent = passwordFrame

local passwordBox = Instance.new("TextBox")
passwordBox.Size = UDim2.new(0.8, 0, 0, 40)
passwordBox.Position = UDim2.new(0.1, 0, 0.35, 0)
passwordBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
passwordBox.BorderColor3 = Color3.fromRGB(0, 255, 0)
passwordBox.Text = ""
passwordBox.PlaceholderText = "Enter Password"
passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passwordBox.TextSize = 16
passwordBox.Font = Enum.Font.Gotham
passwordBox.ClearTextOnFocus = false
passwordBox.Parent = passwordFrame

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0.5, 0, 0, 35)
submitButton.Position = UDim2.new(0.25, 0, 0.65, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
submitButton.Text = "Submit"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 16
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = passwordFrame

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1, 0, 0, 20)
errorLabel.Position = UDim2.new(0, 0, 1, -25)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
errorLabel.TextSize = 14
errorLabel.Font = Enum.Font.Gotham
errorLabel.Parent = passwordFrame

-- Dragging for password frame
local function makeDraggable(frame, dragBar)
    local dragging = false
    local dragInput, mousePos, framePos

    local function update(input)
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end

    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(passwordFrame, passwordTitle)

-- Main Menu
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 80)
mainFrame.Position = UDim2.new(0.5, -200, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, -80, 1, 0)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "VacTec Menu"
menuTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
menuTitle.TextSize = 20
menuTitle.Font = Enum.Font.GothamBold
menuTitle.Parent = titleBar

local expandButton = Instance.new("TextButton")
expandButton.Size = UDim2.new(0, 35, 0, 35)
expandButton.Position = UDim2.new(1, -72, 0, 2.5)
expandButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
expandButton.Text = "▼"
expandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
expandButton.TextSize = 16
expandButton.Font = Enum.Font.GothamBold
expandButton.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -37, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 6
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainFrame

makeDraggable(mainFrame, titleBar)

-- Expand/Collapse
local expanded = false
expandButton.MouseButton1Click:Connect(function()
    expanded = not expanded
    if expanded then
        mainFrame:TweenSize(UDim2.new(0, 400, 0, 450), "Out", "Quad", 0.3, true)
        expandButton.Text = "▲"
    else
        mainFrame:TweenSize(UDim2.new(0, 400, 0, 80), "Out", "Quad", 0.3, true)
        expandButton.Text = "▼"
    end
end)

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 10)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Walk Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = contentFrame

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(1, -20, 0, 20)
sliderBack.Position = UDim2.new(0, 10, 0, 45)
sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBack.BorderColor3 = Color3.fromRGB(0, 255, 0)
sliderBack.Parent = contentFrame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBack

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 1, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderBack

local function updateSpeed(percentage)
    local speed = math.floor(16 + (120 - 16) * percentage)
    speedLabel.Text = "Walk Speed: " .. speed
    humanoid.WalkSpeed = speed
    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
end

local draggingSlider = false

sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

sliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
        local pos = (input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X
        pos = math.clamp(pos, 0, 1)
        updateSpeed(pos)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = (input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X
        pos = math.clamp(pos, 0, 1)
        updateSpeed(pos)
    end
end)

-- Fly Speed Slider
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(1, -20, 0, 30)
flySpeedLabel.Position = UDim2.new(0, 10, 0, 180)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Fly Speed: 50"
flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedLabel.TextSize = 16
flySpeedLabel.Font = Enum.Font.GothamBold
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = contentFrame

local flySliderBack = Instance.new("Frame")
flySliderBack.Size = UDim2.new(1, -20, 0, 20)
flySliderBack.Position = UDim2.new(0, 10, 0, 215)
flySliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flySliderBack.BorderColor3 = Color3.fromRGB(0, 255, 0)
flySliderBack.Parent = contentFrame

local flySliderFill = Instance.new("Frame")
flySliderFill.Size = UDim2.new(0.327, 0, 1, 0)
flySliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
flySliderFill.BorderSizePixel = 0
flySliderFill.Parent = flySliderBack

local flySliderButton = Instance.new("TextButton")
flySliderButton.Size = UDim2.new(0, 20, 1, 0)
flySliderButton.Position = UDim2.new(0.327, -10, 0, 0)
flySliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
flySliderButton.Text = ""
flySliderButton.BorderSizePixel = 0
flySliderButton.Parent = flySliderBack

local function updateFlySpeed(percentage)
    flySpeed = math.floor(16 + (120 - 16) * percentage)
    flySpeedLabel.Text = "Fly Speed: " .. flySpeed
    flySliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    flySliderButton.Position = UDim2.new(percentage, -10, 0, 0)
end

local draggingFlySlider = false

flySliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFlySlider = true
    end
end)

flySliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFlySlider = true
        local pos = (input.Position.X - flySliderBack.AbsolutePosition.X) / flySliderBack.AbsoluteSize.X
        pos = math.clamp(pos, 0, 1)
        updateFlySpeed(pos)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFlySlider = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if draggingFlySlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = (input.Position.X - flySliderBack.AbsolutePosition.X) / flySliderBack.AbsoluteSize.X
        pos = math.clamp(pos, 0, 1)
        updateFlySpeed(pos)
    end
end)

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.48, 0, 0, 40)
flyButton.Position = UDim2.new(0.02, 0, 0, 80)
flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.GothamBold
flyButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
flyButton.Parent = contentFrame

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.48, 0, 0, 40)
noclipButton.Position = UDim2.new(0.5, 0, 0, 80)
noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipButton.Text = "Noclip: OFF"
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.TextSize = 16
noclipButton.Font = Enum.Font.GothamBold
noclipButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
noclipButton.Parent = contentFrame

-- Super Aim Assist Button
local aimAssistButton = Instance.new("TextButton")
aimAssistButton.Size = UDim2.new(1, -20, 0, 40)
aimAssistButton.Position = UDim2.new(0, 10, 0, 130)
aimAssistButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimAssistButton.Text = "Super Aim Assist: OFF"
aimAssistButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimAssistButton.TextSize = 16
aimAssistButton.Font = Enum.Font.GothamBold
aimAssistButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
aimAssistButton.Parent = contentFrame

-- ESP Dropdown
local espDropdown = Instance.new("Frame")
espDropdown.Size = UDim2.new(1, -20, 0, 40)
espDropdown.Position = UDim2.new(0, 10, 0, 250)
espDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espDropdown.BorderColor3 = Color3.fromRGB(0, 255, 0)
espDropdown.ClipsDescendants = true
espDropdown.Parent = contentFrame

local espHeader = Instance.new("TextButton")
espHeader.Size = UDim2.new(1, 0, 0, 40)
espHeader.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espHeader.Text = "ESP ▼"
espHeader.TextColor3 = Color3.fromRGB(0, 255, 0)
espHeader.TextSize = 16
espHeader.Font = Enum.Font.GothamBold
espHeader.BorderSizePixel = 0
espHeader.Parent = espDropdown

local espExpanded = false
espHeader.MouseButton1Click:Connect(function()
    espExpanded = not espExpanded
    if espExpanded then
        espDropdown:TweenSize(UDim2.new(1, -20, 0, 130), "Out", "Quad", 0.2, true)
        espHeader.Text = "ESP ▲"
    else
        espDropdown:TweenSize(UDim2.new(1, -20, 0, 40), "Out", "Quad", 0.2, true)
        espHeader.Text = "ESP ▼"
    end
end)

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1, -10, 0, 40)
espButton.Position = UDim2.new(0, 5, 0, 45)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espButton.Text = "ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 14
espButton.Font = Enum.Font.GothamBold
espButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
espButton.Parent = espDropdown

local teamButton = Instance.new("TextButton")
teamButton.Size = UDim2.new(1, -10, 0, 40)
teamButton.Position = UDim2.new(0, 5, 0, 85)
teamButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teamButton.Text = "Show Team: OFF"
teamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teamButton.TextSize = 14
teamButton.Font = Enum.Font.GothamBold
teamButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
teamButton.Parent = espDropdown

contentFrame.CanvasSize = UDim2.new(0, 0, 0, 400)

-- Fly Function
local flySpeed = 50
local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyButton.Text = "Fly: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local hrp = character:WaitForChild("HumanoidRootPart")
        
        local bv = Instance.new("BodyVelocity")
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp
        
        flying = game:GetService("RunService").Heartbeat:Connect(function()
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local cam = workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)
            
            -- Make character face camera direction
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector * Vector3.new(1, 0, 1))
            
            -- Get humanoid move direction
            local moveDir = humanoid.MoveDirection
            
            -- Check for movement (works on PC and mobile)
            if moveDir.Magnitude > 0 then
                -- Calculate direction based on camera and move direction
                local camCF = cam.CFrame
                local flatCamLook = (camCF.LookVector * Vector3.new(1, 0, 1)).Unit
                local flatCamRight = (camCF.RightVector * Vector3.new(1, 0, 1)).Unit
                
                -- If looking significantly up or down, include Y component
                if math.abs(camCF.LookVector.Y) > 0.1 then
                    direction = camCF.LookVector * moveDir.Z * flySpeed
                    direction = direction + camCF.RightVector * moveDir.X * flySpeed
                else
                    direction = flatCamLook * moveDir.Z * flySpeed
                    direction = direction + flatCamRight * moveDir.X * flySpeed
                end
            end
            
            -- PC keyboard controls
            local UIS = game:GetService("UserInputService")
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + (cam.CFrame.LookVector * flySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - (cam.CFrame.LookVector * flySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - (cam.CFrame.RightVector * flySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + (cam.CFrame.RightVector * flySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, flySpeed, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, flySpeed, 0)
            end
            
            if bv and bv.Parent then
                bv.velocity = direction
            end
        end)
    else
        flyButton.Text = "Fly: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        if flying then 
            flying:Disconnect() 
            flying = nil
        end
        
        if character and character:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(character.HumanoidRootPart:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end

flyButton.MouseButton1Click:Connect(toggleFly)

-- Noclip Function
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipButton.Text = "Noclip: ON"
        noclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        noclipButton.Text = "Noclip: OFF"
        noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end

noclipButton.MouseButton1Click:Connect(toggleNoclip)

game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Super Aim Assist Function
local aimAssistEnabled = false
local aimTarget = nil
local aimConnection = nil
local aimUpdateConnection = nil

local function isEnemy(otherPlayer)
    local myTeam = player.Team
    local otherTeam = otherPlayer.Team
    if not myTeam or not otherTeam then
        return true
    end
    return myTeam ~= otherTeam
end

local function findClosestEnemy()
    local closestDist = math.huge
    local closestTarget = nil
    
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            if isEnemy(otherPlayer) then
                local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = character and character:FindFirstChild("HumanoidRootPart")
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

local function updateAimCamera()
    if aimAssistEnabled and aimTarget and aimTarget.Parent and aimTarget.Parent:FindFirstChild("Humanoid") and aimTarget.Parent.Humanoid.Health > 0 then
        local cam = workspace.CurrentCamera
        local cameraPos = cam.CFrame.Position
        local targetPos = aimTarget.Position + Vector3.new(0, 2, 0)
        local newCFrame = CFrame.new(cameraPos, targetPos)
        cam.CFrame = newCFrame
    end
end

local function toggleAimAssist()
    aimAssistEnabled = not aimAssistEnabled
    if aimAssistEnabled then
        aimAssistButton.Text = "Super Aim Assist: ON"
        aimAssistButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        aimTarget = findClosestEnemy()
        
        aimUpdateConnection = task.spawn(function()
            while aimAssistEnabled do
                aimTarget = findClosestEnemy()
                wait(0.5)
            end
        end)
        
        aimConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if aimAssistEnabled then
                updateAimCamera()
            end
        end)
    else
        aimAssistButton.Text = "Super Aim Assist: OFF"
        aimAssistButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        aimTarget = nil
        
        if aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end
    end
end

aimAssistButton.MouseButton1Click:Connect(toggleAimAssist)

-- ESP Functions
local highlights = {}

local function createHighlight(char, color)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = char
    return highlight
end

local function updateESP()
    for _, v in pairs(highlights) do
        v:Destroy()
    end
    highlights = {}
    
    if espEnabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local color = Color3.fromRGB(200, 0, 255)
                
                if showTeam then
                    if plr.Team == player.Team then
                        color = Color3.fromRGB(0, 255, 0)
                    else
                        color = Color3.fromRGB(255, 0, 0)
                    end
                end
                
                local h = createHighlight(plr.Character, color)
                table.insert(highlights, h)
            end
        end
    end
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espButton.Text = "ESP: ON"
        espButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        espButton.Text = "ESP: OFF"
        espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
    updateESP()
end)

teamButton.MouseButton1Click:Connect(function()
    showTeam = not showTeam
    if showTeam then
        teamButton.Text = "Show Team: ON"
        teamButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        teamButton.Text = "Show Team: OFF"
        teamButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
    updateESP()
end)

game.Players.PlayerAdded:Connect(function()
    wait(1)
    updateESP()
end)

game.Players.PlayerRemoving:Connect(function()
    wait(1)
    updateESP()
end)

-- Password verification
local correctPassword = "VTMA"

submitButton.MouseButton1Click:Connect(function()
    if passwordBox.Text == correctPassword then
        passwordFrame.Visible = false
        mainFrame.Visible = true
    else
        errorLabel.Text = "Incorrect Password!"
        wait(2)
        errorLabel.Text = ""
    end
end)

passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and passwordBox.Text == correctPassword then
        passwordFrame.Visible = false
        mainFrame.Visible = true
    elseif enterPressed then
        errorLabel.Text = "Incorrect Password!"
        wait(2)
        errorLabel.Text = ""
    end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 16
    flyEnabled = false
    flyButton.Text = "Fly: OFF"
    flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    if flying then flying:Disconnect() end
    updateESP()
end)
