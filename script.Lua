local player = game.Players.LocalPlayer
local function createGui()
    local teleportGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local teleportButton = Instance.new("TextButton")
    local resetButton = Instance.new("TextButton")
    local dragButton = Instance.new("TextButton")
    local closeButton = Instance.new("TextButton")
    local teleportListFrame = Instance.new("ScrollingFrame")

    teleportGui.Name = "TeleportGui"
    teleportGui.ResetOnSpawn = false
    teleportGui.Parent = player:WaitForChild("PlayerGui")

    mainFrame.Size = UDim2.new(0, 200, 0, 300)
    mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.Parent = teleportGui

    dragButton.Size = UDim2.new(0.9, 0, 0.05, 0)
    dragButton.Position = UDim2.new(0, 0, 0, 0)
    dragButton.Text = "⋮⋮⋮"
    dragButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dragButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dragButton.Parent = mainFrame

    closeButton.Size = UDim2.new(0.1, 0, 0.05, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = mainFrame

    teleportButton.Size = UDim2.new(0.9, 0, 0.15, 0)
    teleportButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    teleportButton.Text = "Добавить точку телепорта"
    teleportButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.Parent = mainFrame

    resetButton.Size = UDim2.new(0.9, 0, 0.15, 0)
    resetButton.Position = UDim2.new(0.05, 0, 0.3, 0)
    resetButton.Text = "Удалить все точки"
    resetButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetButton.Parent = mainFrame

    teleportListFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
    teleportListFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
    teleportListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    teleportListFrame.BorderSizePixel = 0
    teleportListFrame.ScrollBarThickness = 6
    teleportListFrame.Parent = mainFrame

    local teleportLocations = {}
    local selecting = false
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function updateDrag(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        mainFrame.Position = position
    end

    dragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            updateDrag(input)
        end
    end)

    local function createGlitchEffect(position)
        for i = 1, 10 do
            local glitchPart = Instance.new("Part")
            glitchPart.Size = Vector3.new(math.random(2, 4), math.random(2, 4), math.random(2, 4))
            glitchPart.Position = position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
            glitchPart.Anchored = true
            glitchPart.CanCollide = false
            glitchPart.Material = Enum.Material.Neon
            glitchPart.Transparency = 0.5
            glitchPart.BrickColor = math.random() > 0.5 and BrickColor.new("Maroon") or BrickColor.new("Really black")
            glitchPart.Parent = workspace
            
            spawn(function()
                for j = 1, 5 do
                    glitchPart.Transparency = math.random(2, 8) / 10
                    glitchPart.Position = position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
                    glitchPart.BrickColor = math.random() > 0.5 and BrickColor.new("Maroon") or BrickColor.new("Really black")
                    task.wait(0.05)
                end
                glitchPart:Destroy()
            end)
        end
    end

    local function createTeleportEffect(character)
        for i = 1, 2 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Transparency = 0.5
            part.Anchored = true
            part.CanCollide = false
            part.CFrame = character.HumanoidRootPart.CFrame
            part.Parent = workspace
            
            local emitter = Instance.new("ParticleEmitter")
            emitter.Texture = "rbxassetid://8073198957"
            emitter.Rate = 500
            emitter.Speed = NumberRange.new(5, 10)
            emitter.SpreadAngle = Vector2.new(180, 180)
            emitter.Lifetime = NumberRange.new(0.2, 0.5)
            emitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2),
                NumberSequenceKeypoint.new(1, 0)
            })
            emitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            emitter.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            })
            emitter.Parent = part
            emitter:Emit(100)
            
            game:GetService("Debris"):AddItem(part, 0.5)
        end
    end

    local function teleportToLocation(position)
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local startPos = humanoidRootPart.Position
                createTeleportEffect(character)
                createGlitchEffect(startPos)
                task.wait(0.1)
                humanoidRootPart.CFrame = CFrame.new(position)
                createTeleportEffect(character)
                createGlitchEffect(position)
            end
        end
    end

    local function updateTeleportList()
        for _, child in pairs(teleportListFrame:GetChildren()) do
            child:Destroy()
        end
        
        for i, locationData in ipairs(teleportLocations) do
            local button = Instance.new("Frame")
            button.Size = UDim2.new(0.95, 0, 0, 30)
            button.Position = UDim2.new(0.025, 0, 0, (i - 1) * 35)
            button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            button.Parent = teleportListFrame
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            nameLabel.Text = locationData.name
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Parent = button
            
            local teleportBtn = Instance.new("TextButton")
            teleportBtn.Size = UDim2.new(0.2, 0, 1, 0)
            teleportBtn.Position = UDim2.new(0.6, 0, 0, 0)
            teleportBtn.Text = "→"
            teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            teleportBtn.Parent = button
            
            local deleteBtn = Instance.new("TextButton")
            deleteBtn.Size = UDim2.new(0.2, 0, 1, 0)
            deleteBtn.Position = UDim2.new(0.8, 0, 0, 0)
            deleteBtn.Text = "X"
            deleteBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            deleteBtn.Parent = button
            
            local currentPosition = locationData.position
            local currentIndex = i
            
            teleportBtn.MouseButton1Click:Connect(function()
                teleportToLocation(currentPosition)
            end)
            
            deleteBtn.MouseButton1Click:Connect(function()
                table.remove(teleportLocations, currentIndex)
                updateTeleportList()
            end)
        end
        
        teleportListFrame.CanvasSize = UDim2.new(0, 0, 0, #teleportLocations * 35)
    end

    local function startSelection()
        selecting = true
        teleportButton.Text = "Кликните по месту для телепорта"
        
        local mouse = player:GetMouse()
        
        local function mouseClick()
            if selecting then
                local newLocation = {
                    position = mouse.Hit.Position,
                    name = "Точка #" .. (#teleportLocations + 1)
                }
                table.insert(teleportLocations, newLocation)
                selecting = false
                teleportButton.Text = "Добавить точку телепорта"
                updateTeleportList()
                mouse.Button1Up:Disconnect()
            end
        end
        
        mouse.Button1Up:Connect(mouseClick)
    end

    local function resetTeleportLocations()
        teleportLocations = {}
        selecting = false
        teleportButton.Text = "Добавить точку телепорта"
        updateTeleportList()
    end

    local function handleTeleport()
        if not selecting then
            startSelection()
        end
    end

    local function closeGui()
        teleportGui:Destroy()
    end

    teleportButton.MouseButton1Click:Connect(handleTeleport)
    resetButton.MouseButton1Click:Connect(resetTeleportLocations)
    closeButton.MouseButton1Click:Connect(closeGui)
end

player.CharacterAdded:Connect(function()
    if not player.PlayerGui:FindFirstChild("TeleportGui") then
        createGui()
    end
end)

createGui()
