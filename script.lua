local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Bnyk Hub | Build a Boat", HidePremium = false, SaveConfig = true, ConfigFolder = "BnykHubConfig"})

-- ПЕРЕМЕННЫЕ
getgenv().AutoFarm = false
getgenv().Noclip = false
local LocalPlayer = game.Players.LocalPlayer

-- Функция для Ноуклипа
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- РАЗДЕЛ GENERAL
local GeneralTab = Window:MakeTab({
	Name = "General",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Красивая полоска (Слайдер) скорости
GeneralTab:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 300,
	Default = 16,
	Color = Color3.fromRGB(0, 150, 255),
	Increment = 1,
	ValueName = "скорость",
	Callback = function(Value)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
	end    
})

-- Красивый переключатель Ноуклипа
GeneralTab:AddToggle({
	Name = "Noclip (Проход сквозь стены)",
	Default = false,
	Callback = function(Value)
		getgenv().Noclip = Value
	end
})

-- РАЗДЕЛ FARM
local FarmTab = Window:MakeTab({
	Name = "Auto Farm",
	Icon = "rbxassetid://4483362458",
	PremiumOnly = false
})

FarmTab:AddToggle({
	Name = "Включить автофарм",
	Default = false,
	Callback = function(Value)
		getgenv().AutoFarm = Value
        
        spawn(function()
            while getgenv().AutoFarm do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    
                    -- Создаем временную платформу, чтобы персонаж не падал в пустоту при ТП
                    local plat = Instance.new("Part", workspace)
                    plat.Size = Vector3.new(10, 1, 10)
                    plat.Anchored = true
                    plat.Transparency = 1
                    
                    -- Летим по стадиям
                    for i = 1, 10 do
                        if not getgenv().AutoFarm then break end
                        local stage = workspace.BoatStages.OtherStages["Stage"..i]
                        if stage and stage:FindFirstChild("GoldenChest") then
                            local targetCFrame = stage.GoldenChest.CFrame + Vector3.new(0, 3, 0)
                            plat.CFrame = targetCFrame - Vector3.new(0, 3.5, 0)
                            char.HumanoidRootPart.CFrame = targetCFrame
                            wait(2) -- Время на прогрузку стадии игрой
                        end
                    end
                    
                    -- Финишный сундук
                    if getgenv().AutoFarm then
                        local theEnd = workspace.BoatStages.NormalStages:FindFirstChild("TheEnd")
                        if theEnd and theEnd:FindFirstChild("GoldenChest") then
                            plat.CFrame = theEnd.GoldenChest.CFrame - Vector3.new(0, 3.5, 0)
                            char.HumanoidRootPart.CFrame = theEnd.GoldenChest.CFrame + Vector3.new(0, 3, 0)
                            wait(5) -- Ждем золото и респавн
                        end
                    end
                    
                    plat:Destroy()
                end
                wait(1)
            end
        end)
	end
})

OrionLib:Init()
