local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "bnyk Hub | Build a Boat",
    SubTitle = "by Gemini",
    TabWidth = 160,
    Size = Vector2.new(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Переменные для функций
local Options = Fluent.Options
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local NoClipEnabled = false
local AutoFarmEnabled = false

-- Обновление персонажа при респавне
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
end)

-- Проверка NoClip
game:GetService("RunService").Stepped:Connect(function()
    if NoClipEnabled and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

------------------------------------------------------------------------
-- ВКЛАДКА: GENERAL (ГЛАВНОЕ)
------------------------------------------------------------------------
local TabGeneral = Window:AddTab({ Title = "General", Icon = "settings" })

TabGeneral:AddSlider("SpeedSlider", {
    Title = "Скорость (SpeedHack)",
    Description = "Изменяет скорость бега",
    Default = 16,
    Min = 16,
    Max = 150,
    Rounding = 0,
    Callback = function(Value)
        if Humanoid then Humanoid.WalkSpeed = Value end
    end
})

TabGeneral:AddSlider("JumpSlider", {
    Title = "Высота прыжка (JumpPower)",
    Description = "Изменяет силу прыжка",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        if Humanoid then 
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = Value 
        end
    end
})

TabGeneral:AddToggle("NoClipToggle", {
    Title = "Прохождение сквозь стены (NoClip)",
    Default = false,
    Callback = function(Value)
        NoClipEnabled = Value
    end
})

------------------------------------------------------------------------
-- ВКЛАДКА: VISUALS (ВИЗУАЛЫ)
------------------------------------------------------------------------
local TabVisuals = Window:AddTab({ Title = "Visuals", Icon = "eye" })

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local function ApplyESP(char)
        if char:FindFirstChild("BAB_ESP") then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "BAB_ESP"
        highlight.FillColor = Color3.fromRGB(0, 255, 120)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = char
        highlight.Parent = char
    end

    if player.Character then ApplyESP(player.Character) end
    player.CharacterAdded:Connect(ApplyESP)
end

TabVisuals:AddToggle("ESPToggle", {
    Title = "Подсветка игроков (ESP)",
    Default = false,
    Callback = function(Value)
        if Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                CreateESP(player)
            end
            _G.ESPConnection = game.Players.PlayerAdded:Connect(CreateESP)
        else
            if _G.ESPConnection then _G.ESPConnection:Disconnect() end
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("BAB_ESP") then
                    player.Character.BAB_ESP:Destroy()
                end
            end
        end
    end
})

------------------------------------------------------------------------
-- ВКЛАДКА: AUTOMATION (АВТОМАТИЗАЦИЯ)
------------------------------------------------------------------------
local TabAutomation = Window:AddTab({ Title = "Automation", Icon = "play" })

-- Функция умного авто-фарма (ТП по стадиям, чтобы засчитывало золото)
local function DoAutoFarm()
    while AutoFarmEnabled do
        local rootPart = Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            -- Отключаем падение, чтобы не умереть в воде во время ТП
            Humanoid.PlatformStand = true 
            
            -- Летим по стадиям (всего 10 зон)
            for i = 1, 10 do
                if not AutoFarmEnabled then break end
                local zone = workspace:FindFirstChild("TheBlackZone") or workspace:FindFirstChild("Zone" .. i)
                -- Безопасный телепорт к чекпоинтам стадий
                rootPart.CFrame = CFrame.new(0, -10, i * 850) -- Среднее расстояние между стадиями в этой игре
                task.wait(1.5) -- Небольшая задержка, чтобы игра засчитала прохождение зоны
            end
            
            -- Телепорт прямо к сундуку в конце
            if AutoFarmEnabled then
                rootPart.CFrame = CFrame.new(16, -15, 9495) -- Координаты финального сундука
                task.wait(3) -- Ждем анимацию открытия сундука и респавн
            end
        end
        task.wait(1)
    end
    if Humanoid then Humanoid.PlatformStand = false end
end

TabAutomation:AddToggle("AutoFarmToggle", {
    Title = "Авто-фарм золота (Auto-Chest)",
    Description = "Автоматически летит по стадиям к финальному сундуку",
    Default = false,
    Callback = function(Value)
        AutoFarmEnabled = Value
        if Value then
            task.spawn(DoAutoFarm)
        end
    end
})

-- Уведомление о запуске
Fluent:Notify({
    Title = "bnyk Hub",
    Content = "Скрипт успешно загружен в Delta!",
    Duration = 5
})

Window:SelectTab(1)
