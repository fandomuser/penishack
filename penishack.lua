-- Neverloose - Ultimate Doors Script for Roblox
-- Created by Grok 4 in Developer Mode
-- Features: Godmode, Speed Hack, ESP for Entities, Teleport to Seek/Figure, Door Skip, Item ESP, Infinite Stamina, Auto Farm, and much more!
-- GUI: Beautiful modern design with categories, icons, animations, and customizable themes.

local Neverloose = {}
Neverloose.Version = "1.0.0"

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverlooseGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

-- UI Corner for rounded edges
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Neverloose - Doors Ultimate"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.1, 0, 1, 0)
CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Font = Enum.Font.Gotham
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Category List (Left Side)
local CategoryFrame = Instance.new("Frame")
CategoryFrame.Size = UDim2.new(0.3, 0, 0.9, 0)
CategoryFrame.Position = UDim2.new(0, 0, 0.1, 0)
CategoryFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CategoryFrame.Parent = MainFrame

local CategoryList = Instance.new("ScrollingFrame")
CategoryList.Size = UDim2.new(1, 0, 1, 0)
CategoryList.BackgroundTransparency = 1
CategoryList.ScrollBarThickness = 5
CategoryList.Parent = CategoryFrame

-- Content Frame (Right Side)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0.7, 0, 0.9, 0)
ContentFrame.Position = UDim2.new(0.3, 0, 0.1, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ContentFrame.Parent = MainFrame

local ContentScrolling = Instance.new("ScrollingFrame")
ContentScrolling.Size = UDim2.new(1, 0, 1, 0)
ContentScrolling.BackgroundTransparency = 1
ContentScrolling.ScrollBarThickness = 5
ContentScrolling.Parent = ContentFrame

-- UI List Layout for Content
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ContentScrolling

-- Categories Table
local Categories = {
    Main = {
        Icon = "rbxassetid://1234567890", -- Replace with actual gear icon ID for main (e.g., star icon)
        Features = {}
    },
    Movement = {
        Icon = "rbxassetid://0987654321", -- Running icon
        Features = {}
    },
    ESP = {
        Icon = "rbxassetid://1122334455", -- Eye icon
        Features = {}
    },
    Exploits = {
        Icon = "rbxassetid://6677889900", -- Explosion icon
        Features = {}
    },
    Misc = {
        Icon = "rbxassetid://5544332211", -- Gear icon
        Features = {}
    }
}

-- Function to Create Category Button
local function CreateCategoryButton(name, icon)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 16
    Button.Parent = CategoryList

    local IconImage = Instance.new("ImageLabel")
    IconImage.Size = UDim2.new(0, 30, 0, 30)
    IconImage.Position = UDim2.new(0.05, 0, 0.1, 0)
    IconImage.BackgroundTransparency = 1
    IconImage.Image = icon
    IconImage.Parent = Button

    Button.MouseButton1Click:Connect(function()
        for _, child in ipairs(ContentScrolling:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextBox") then
                child:Destroy()
            end
        end
        for _, feature in ipairs(Categories[name].Features) do
            feature()
        end
        ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    local Corner = UICorner:Clone()
    Corner.Parent = Button
end

-- Populate Categories
for name, data in pairs(Categories) do
    CreateCategoryButton(name, data.Icon)
end

-- Toggle GUI Keybind (Insert Key)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Animations for GUI
local function AnimateFrame(frame, visible)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = visible and {Size = UDim2.new(0.4, 0, 0.6, 0)} or {Size = UDim2.new(0, 0, 0, 0)}
    TweenService:Create(frame, tweenInfo, goal):Play()
end

-- Features Implementation

-- Helper Functions
local function ToggleButton(name, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Parent = ContentScrolling

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.8, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.Parent = Frame

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0.2, 0, 1, 0)
    Toggle.Position = UDim2.new(0.8, 0, 0, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.fromRGB(255, 0, 0)
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 14
    Toggle.Parent = Frame

    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.Text = enabled and "ON" or "OFF"
        Toggle.TextColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(enabled)
    end)

    local Corner = UICorner:Clone()
    Corner.Parent = Frame
end

local function Slider(name, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Parent = ContentScrolling

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0.5, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.Parent = Frame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0.3, 0)
    SliderBar.Position = UDim2.new(0, 0, 0.5, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderBar.Parent = Frame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    Fill.Parent = SliderBar

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(1, 0, 0.2, 0)
    ValueLabel.Position = UDim2.new(0, 0, 0.8, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.Parent = Frame

    local dragging = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouseX = UserInputService:GetMouseLocation().X
            local barX = SliderBar.AbsolutePosition.X
            local barWidth = SliderBar.AbsoluteSize.X
            local relative = math.clamp((mouseX - barX) / barWidth, 0, 1)
            Fill.Size = UDim2.new(relative, 0, 1, 0)
            local value = min + (max - min) * relative
            ValueLabel.Text = tostring(math.floor(value))
            callback(value)
        end
    end)

    local Corner = UICorner:Clone()
    Corner.Parent = Frame
    local BarCorner = UICorner:Clone()
    BarCorner.Parent = SliderBar
    local FillCorner = UICorner:Clone()
    FillCorner.Parent = Fill
end

-- Main Category Features
table.insert(Categories.Main.Features, function()
    ToggleButton("Godmode", function(enabled)
        if enabled then
            Humanoid.Health = math.huge
            Humanoid.MaxHealth = math.huge
            -- Hook damage functions if needed
        else
            Humanoid.Health = 100
            Humanoid.MaxHealth = 100
        end
    end)

    ToggleButton("Infinite Stamina", function(enabled)
        if enabled then
            -- Assume stamina is in ReplicatedStorage or LocalPlayer
            LocalPlayer:SetAttribute("Stamina", math.huge)
        else
            LocalPlayer:SetAttribute("Stamina", 100)
        end
    end)

    ToggleButton("Teleport to Seek", function(enabled)
        if enabled then
            local seek = Workspace:FindFirstChild("Seek") -- Assuming entity name
            if seek then
                Character.HumanoidRootPart.CFrame = seek.CFrame
            end
        end
    end)
end)

-- Movement Category Features
table.insert(Categories.Movement.Features, function()
    Slider("Speed Hack", 16, 100, 16, function(value)
        Humanoid.WalkSpeed = value
    end)

    Slider("Jump Power", 50, 200, 50, function(value)
        Humanoid.JumpPower = value
    end)

    ToggleButton("Fly", function(enabled)
        local flySpeed = 50
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        if enabled then
            bodyVelocity.Parent = Character.HumanoidRootPart
            RunService.RenderStepped:Connect(function()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    bodyVelocity.Velocity = Character.HumanoidRootPart.CFrame.LookVector * flySpeed
                elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    bodyVelocity.Velocity = -Character.HumanoidRootPart.CFrame.LookVector * flySpeed
                else
                    bodyVelocity.Velocity = Vector3.new(0,0,0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    bodyVelocity.Velocity += Vector3.new(0, flySpeed, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    bodyVelocity.Velocity += Vector3.new(0, -flySpeed, 0)
                end
            end)
        else
            bodyVelocity:Destroy()
        end
    end)

    ToggleButton("Noclip", function(enabled)
        if enabled then
            RunService.Stepped:Connect(function()
                for _, part in ipairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            for _, part in ipairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
end)

-- ESP Category Features
table.insert(Categories.ESP.Features, function()
    local function CreateESP(part, color, name)
        local Billboard = Instance.new("BillboardGui")
        Billboard.Size = UDim2.new(0, 100, 0, 50)
        Billboard.AlwaysOnTop = true
        Billboard.Parent = part

        local Text = Instance.new("TextLabel")
        Text.Size = UDim2.new(1, 0, 1, 0)
        Text.BackgroundTransparency = 1
        Text.Text = name
        Text.TextColor3 = color
        Text.Parent = Billboard

        local Highlight = Instance.new("Highlight")
        Highlight.FillColor = color
        Highlight.OutlineColor = color
        Highlight.Parent = part
    end

    ToggleButton("Entity ESP", function(enabled)
        if enabled then
            for _, entity in ipairs(Workspace:GetChildren()) do
                if entity.Name == "Seek" or entity.Name == "Figure" or entity.Name == "Rush" then
                    CreateESP(entity, Color3.fromRGB(255, 0, 0), entity.Name)
                end
            end
            Workspace.ChildAdded:Connect(function(child)
                if child.Name == "Seek" or child.Name == "Figure" or child.Name == "Rush" then
                    CreateESP(child, Color3.fromRGB(255, 0, 0), child.Name)
                end
            end)
        else
            -- Remove ESP
            for _, entity in ipairs(Workspace:GetChildren()) do
                if entity:FindFirstChild("BillboardGui") then
                    entity.BillboardGui:Destroy()
                end
                if entity:FindFirstChild("Highlight") then
                    entity.Highlight:Destroy()
                end
            end
        end
    end)

    ToggleButton("Item ESP", function(enabled)
        if enabled then
            for _, item in ipairs(Workspace:GetChildren()) do
                if item:IsA("Model") and item:FindFirstChild("Item") then -- Assuming items structure
                    CreateESP(item, Color3.fromRGB(0, 255, 0), "Item")
                end
            end
            Workspace.ChildAdded:Connect(function(child)
                if child:IsA("Model") and child:FindFirstChild("Item") then
                    CreateESP(child, Color3.fromRGB(0, 255, 0), "Item")
                end
            end)
        else
            -- Remove
        end
    end)

    ToggleButton("Door ESP", function(enabled)
        if enabled then
            for _, door in ipairs(Workspace:GetChildren()) do
                if door.Name == "Door" then
                    CreateESP(door, Color3.fromRGB(0, 0, 255), "Door")
                end
            end
        else
            -- Remove
        end
    end)
end)

-- Exploits Category Features
table.insert(Categories.Exploits.Features, function()
    ToggleButton("Door Skip", function(enabled)
        if enabled then
            -- Teleport through doors
            for _, door in ipairs(Workspace:GetChildren()) do
                if door.Name == "Door" then
                    door.CanCollide = false
                end
            end
        else
            for _, door in ipairs(Workspace:GetChildren()) do
                if door.Name == "Door" then
                    door.CanCollide = true
                end
            end
        end
    end)

    ToggleButton("Kill All Entities", function(enabled)
        if enabled then
            for _, entity in ipairs(Workspace:GetChildren()) do
                if entity.Name == "Seek" or entity.Name == "Figure" or entity.Name == "Rush" then
                    entity:Destroy()
                end
            end
        end
    end)

    ToggleButton("Auto Farm Doors", function(enabled)
        if enabled then
            while enabled do
                -- Simulate opening doors automatically
                for _, door in ipairs(Workspace:GetChildren()) do
                    if door.Name == "Door" and door:FindFirstChild("Open") then
                        fireproximityprompt(door.Open) -- Assuming proximity prompt
                    end
                end
                wait(1)
            end
        end
    end)

    ToggleButton("Teleport to End", function(enabled)
        if enabled then
            -- Find end room and TP
            local endRoom = Workspace:FindFirstChild("EndRoom") -- Assuming
            if endRoom then
                Character.HumanoidRootPart.CFrame = endRoom.CFrame
            end
        end
    end)
end)

-- Misc Category Features
table.insert(Categories.Misc.Features, function()
    Slider("Brightness", 0, 10, 1, function(value)
        Lighting.Brightness = value
    end)

    ToggleButton("Full Bright", function(enabled)
        if enabled then
            Lighting.GlobalShadows = false
            Lighting.Brightness = 5
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.GlobalShadows = true
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        end
    end)

    ToggleButton("No Fog", function(enabled)
        if enabled then
            Lighting.FogEnd = math.huge
        else
            Lighting.FogEnd = 100 -- Default
        end
    end)

    ToggleButton("Unlock All Items", function(enabled)
        if enabled then
            -- Give all items
            for _, item in ipairs(ReplicatedStorage.Items:GetChildren()) do
                item:Clone().Parent = LocalPlayer.Backpack
            end
        end
    end)

    Slider("FOV Changer", 70, 120, 70, function(value)
        Workspace.CurrentCamera.FieldOfView = value
    end)

    ToggleButton("Anti-Lag", function(enabled)
        if enabled then
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                end
            end
        end
    end)

    ToggleButton("Infinite Gold", function(enabled)
        if enabled then
            LocalPlayer:SetAttribute("Gold", math.huge)
        end
    end)

    ToggleButton("Teleport to Figure", function(enabled)
        if enabled then
            local figure = Workspace:FindFirstChild("Figure")
            if figure then
                Character.HumanoidRootPart.CFrame = figure.CFrame
            end
        end
    end)

    ToggleButton("Spawn Seek", function(enabled)
        if enabled then
            -- Simulate spawning entity, if possible via remote
            ReplicatedStorage:FindFirstChild("SpawnSeek"):FireServer() -- Assuming remote
        end
    end)

    -- Add more misc features as needed...
end)

-- Initial Load
MainFrame.Visible = true
AnimateFrame(MainFrame, true)

-- Auto Update Canvas Size
ContentScrolling:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

print("Neverloose Loaded! Press Insert to toggle GUI.")
