-- Сначала грузим саму библиотеку интерфейса
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusZHub/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Bnyk Hub | Build a Boat",
   LoadingTitle = "Запуск системы...",
   LoadingSubtitle = "by bnyk",
   ConfigurationSaving = { Enabled = false }
})

-- Раздел General
local GeneralTab = Window:CreateTab("General", 4483362458)

-- Тот самый красивый слайдер скорости
GeneralTab:AddSlider({
   Name = "Speed Hack",
   Min = 16,
   Max = 300,
   Default = 16,
   Color = Color3.fromRGB(255, 0, 0),
   Increment = 1,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Тот самый красивый переключатель Noclip
GeneralTab:AddToggle({
   Name = "Noclip",
   Default = false,
   Callback = function(Value)
      getgenv().Noclip = Value
      game:GetService("RunService").Stepped:Connect(function()
          if getgenv().Noclip and game.Players.LocalPlayer.Character then
              for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                  if v:IsA("BasePart") then v.CanCollide = false end
              end
          end
      end)
   end,
})

-- Кнопка для Infinite Yield (чтобы он не мешал основному меню)
GeneralTab:AddButton({
   Name = "Запустить Infinite Yield (Админка)",
   Callback = function()
       loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

-- Секция Автофарма
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
FarmTab:AddToggle({
   Name = "Start Farming",
   Default = false,
   Callback = function(Value)
      getgenv().AutoFarm = Value
      -- Тут твоя логика полета к сундуку...
   end,
})
