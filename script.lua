-- Удаляем старое меню, если оно вдруг зависло в памяти
if game.CoreGui:FindFirstChild("BnykHub") then
    game.CoreGui.BnykHub:Destroy()
end

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmToggle = Instance.new("TextButton")
local TPButton = Instance.new("TextButton")
local SpeedButton = Instance.new("TextButton")

ScreenGui.Name = "BnykHub"
ScreenGui.Parent = game.CoreGui

-- Главное окно
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- Можно двигать по экрану

-- Заголовок
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Bnyk Hub - Build a Boat"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Кнопка: Автофарм
FarmToggle.Name = "FarmToggle"
FarmToggle.Parent = MainFrame
FarmToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FarmToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
FarmToggle.Size = UDim2.new(0.9, 0, 0, 40)
FarmToggle.Font = Enum.Font.SourceSans
FarmToggle.Text = "Auto Farm: OFF"
FarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmToggle.TextSize = 16

-- Кнопка: ТП на финиш
TPButton.Name = "TPButton"
TPButton.Parent = MainFrame
TPButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TPButton.Position = UDim2.new(0.05, 0, 0.48, 0)
TPButton.Size = UDim2.new(0.9, 0, 0, 40)
TPButton.Font = Enum.Font.SourceSans
TPButton.Text = "Teleport to End"
TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TPButton.TextSize = 16

-- Кнопка: Скорость бега
SpeedButton.Name = "SpeedButton"
SpeedButton.Parent = MainFrame
SpeedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedButton.Position = UDim2.new(0.05, 0, 0.71, 0)
SpeedButton.Size = UDim2.new(0.9, 0, 0, 40)
SpeedButton.Font = Enum.Font.SourceSans
SpeedButton.Text = "Speed: Normal"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.TextSize = 16

-- Логика функций
getgenv().AutoFarm = false
FarmToggle.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    if getgenv().AutoFarm then
        FarmToggle.Text = "Auto Farm: ON"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        FarmToggle.Text = "Auto Farm: OFF"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
    
    spawn(function()
        while getgenv().AutoFarm do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for i = 1, 10 do
                    if not getgenv().AutoFarm then break end
                    local stage = game:GetService("Workspace").BoatStages.OtherStages["Stage"..i]
                    if stage and stage:FindFirstChild("GoldenChest") then
                        char.HumanoidRootPart.CFrame = stage.GoldenChest.CFrame
                        wait(2.5) -- Безопасная задержка для зачисления золота
                    end
                end
                if getgenv().AutoFarm then
                    local theEnd = game:GetService("Workspace").BoatStages.NormalStages:FindFirstChild("TheEnd")
                    if theEnd and theEnd:FindFirstChild("GoldenChest") then
                        char.HumanoidRootPart.CFrame = theEnd.GoldenChest.CFrame
                        wait(6) -- Ждем респавна на базе
                    end
                end
            end
            wait(1)
        end
    end)
end)

TPButton.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local theEnd = game:GetService("Workspace").BoatStages.NormalStages:FindFirstChild("TheEnd")
        if theEnd and theEnd:FindFirstChild("GoldenChest") then
            char.HumanoidRootPart.CFrame = theEnd.GoldenChest.CFrame
        end
    end
end)

local speedToggle = false
SpeedButton.MouseButton1Click:Connect(function()
    speedToggle = not speedToggle
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if speedToggle then
            char.Humanoid.WalkSpeed = 150
            SpeedButton.Text = "Speed: FAST"
            SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 120, 150)
        else
            char.Humanoid.WalkSpeed = 16
            SpeedButton.Text = "Speed: Normal"
            SpeedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end
end)
