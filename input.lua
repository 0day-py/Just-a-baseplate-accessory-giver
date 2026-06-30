local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GearRemoteGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 260)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(60, 60, 80)
frameStroke.Thickness = 2
frameStroke.Parent = mainFrame

-- The world is on fire Burn Burn Burn
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar


local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Accessory Spawner [FE]"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- SHA 256 Ultra Eniox instance loadstring("yourmother")
local idTextBox = Instance.new("TextBox")
idTextBox.Name = "IDInput"
idTextBox.Size = UDim2.new(0.9, 0, 0, 130)
idTextBox.Position = UDim2.new(0.05, 0, 0, 45)
idTextBox.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
idTextBox.BorderSizePixel = 0
idTextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
idTextBox.PlaceholderText = "Paste Gear IDs here (space separated)..."
idTextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
idTextBox.TextSize = 14
idTextBox.Font = Enum.Font.Gotham
idTextBox.ClearTextOnFocus = false
idTextBox.MultiLine = true
idTextBox.TextWrapped = true
idTextBox.Parent = mainFrame
idTextBox.Text = ""

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 6)
textBoxCorner.Parent = idTextBox

local textBoxStroke = Instance.new("UIStroke")
textBoxStroke.Color = Color3.fromRGB(50, 50, 70)
textBoxStroke.Parent = idTextBox

-- else where ehen if or not because im not stop tryna skid u skid
local fireButton = Instance.new("TextButton")
fireButton.Name = "FireButton"
fireButton.Size = UDim2.new(0.9, 0, 0, 40)
fireButton.Position = UDim2.new(0.05, 0, 1, -55)
fireButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
fireButton.BorderSizePixel = 0
fireButton.Text = "Equip accessories"
fireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fireButton.TextSize = 16
fireButton.Font = Enum.Font.GothamBold
fireButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = fireButton

-- B4ckshots for u 1f u r45d th1s
fireButton.MouseEnter:Connect(function()
    fireButton.BackgroundColor3 = Color3.fromRGB(85, 125, 245)
end)
fireButton.MouseLeave:Connect(function()
    fireButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
end)

local dragging = false
local dragInput, mousePos, framePos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(
            framePos.X.Scale, framePos.X.Offset + delta.X,
            framePos.Y.Scale, framePos.Y.Offset + delta.Y
        )
    end
end)

local remoteEvent = ReplicatedStorage:FindFirstChild("01_server")

fireButton.MouseButton1Click:Connect(function()
    -- payload, chunk, xor, cross keys,byte
    if not remoteEvent then
        remoteEvent = ReplicatedStorage:FindFirstChild("01_server")
        if not remoteEvent then
            warn("[Gear GUI] Remote event '01_server' not found in ReplicatedStorage!")
            return
        end
    end

    local rawText = idTextBox.Text
    local cleanIds = rawText:gsub("^%s*(.-)%s*$", "%1"):gsub("%s+", " ")

    if cleanIds == "" then
        warn("[Gear GUI] No Gear IDs entered in the text box!")
        return
    end

    local commandString = "-gh " .. cleanIds

    local success, err = pcall(function()
        remoteEvent:FireServer("cmd", commandString)
    end)

    if success then
        print("[Gear GUI] Successfully equipped item(s): " .. commandString)
        fireButton.Text = "Success!"
        fireButton.BackgroundColor3 = Color3.fromRGB(46, 184, 46)
    else
        warn("[Gear GUI] Failed to fire remote: " .. tostring(err))
        fireButton.Text = "Error Firing!"
        fireButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end

    task.delay(1.5, function()
        if fireButton then
            fireButton.Text = "Equip accessories"
            fireButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
        end
    end)
end)
