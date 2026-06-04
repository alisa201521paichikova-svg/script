local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusZHub/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Bnyk Hub | Build a Boat",
   LoadingTitle = "Загрузка Bnyk Hub...",
   LoadingSubtitle = "by bnyk",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false -- Ключ не нужен, открывается сразу
})

-- Переменные
getgenv().AutoFarm = false
getgenv().Noclip = false
local LocalPlayer = game.Players.LocalPlayer

-- Логика Ноуклипа (каждый кадр отключаем коллизию)
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ВКЛАДКА GENERAL
local GeneralTab = Window:CreateTab("General", 4483362458) -- Иконка для вкладки

-- Красивый слайдер скорости
local SpeedSlider = GeneralTab:CreateSlider({
   Name = "WalkSpeed (Скорость бега)",
   Info = "Передвигай ползунок, чтобы изменить скорость",
   Increment = 1,
   Suffix = "скорость",
   CurrentValue = 16,
   Flag = "SpeedSlider", 
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
          LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Красивый переключатель Ноуклипа
local NoclipToggle = GeneralTab:CreateToggle({
   Name = "Noclip (Сквозь стены)",
   CurrentValue = false,
   Flag = "NoclipToggle", 
   Callback = function(Value)
      getgenv().Noclip = Value
   end,
})

-- ВКЛАДКА AUTO FARM
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

local FarmToggle = FarmTab:CreateToggle({
   Name = "Включить Автофарм денег",
   CurrentValue = false,
   Flag = "FarmToggle", 
   Callback = function(Value)
      getgenv().AutoFarm = Value
      
      spawn(function()
          while getgenv().AutoFarm do
              local char = LocalPlayer.Character
              if char and char:FindFirstChild("HumanoidRootPart") then
                  
                  -- Создаем невидимую платформу, чтобы Delta не кикала за полет
                  local plat = Instance.new("Part", workspace)
                  plat.Size = Vector3.new(10, 1, 10)
                  plat.Anchored = true
                  plat.Transparency = 1
                  
                  -- Летим по стадиям (от 1 до 10)
                  for i = 1, 10 do
                      if not getgenv().AutoFarm then break end
                      local stage = workspace.BoatStages.OtherStages["Stage"..i]
                      if stage and stage:FindFirstChild("GoldenChest") then
                          local targetCFrame = stage.GoldenChest.CFrame + Vector3.new(0, 3, 0)
                          plat.CFrame = targetCFrame - Vector3.new(0, 3.5, 0)
                          char.HumanoidRootPart.CFrame = targetCFrame
                          task.wait(2) -- Задержка, чтобы игра засчитала прохождение уровня
                      end
                  end
                  
                  -- Летим к сундуку на финише
                  if getgenv().AutoFarm then
                      local theEnd = workspace.BoatStages.NormalStages:FindFirstChild("TheEnd")
                      if theEnd and theEnd:FindFirstChild("GoldenChest") then
                          plat.CFrame = theEnd.GoldenChest.CFrame - Vector3.new(0, 3.5, 0)
                          char.HumanoidRootPart.CFrame = theEnd.GoldenChest.CFrame + Vector3.new(0, 3, 0)
                          task.wait(6) -- Ждем респавна на базе после получения золота
                      end
                  end
                  
                  plat:Destroy()
              end
              task.wait(1)
          end
      end)
   end,
})

-- Уведомление о том, что скрипт успешно загружен!
Rayfield:Notify({
   Title = "Bnyk Hub",
   Content = "Скрипт успешно активирован!",
   Duration = 5,
   Image = 4483362458,
})
