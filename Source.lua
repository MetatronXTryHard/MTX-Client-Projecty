local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RedzLibV5/main/Source.Lua"))()
local Window = redzlib:MakeWindow({
  Title = "🥋 MTX Client | Blox Fruits 👑",
  SubTitle = "By MTX Team | V2.5",
  SaveFolder = "MTX Client Save.lua"
})



local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerLevel = Player.Data.Level
local Quest = {CFrame.new(), CFrame.new(), "", "", 1}
local QuestTween = {}
local TPIsland, TPIslandDistance = nil, nil
local Sea1, Sea2, Sea3 = game.PlaceId == 2753915549, game.PlaceId == 4442272183, game.PlaceId == 7449423635

local character = Player.Character or Player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local block = Instance.new("Part", workspace)
block.Size = Vector3.new(1, 1, 1)
block.Name = "player platform .........."
block.Anchored = true
block.CanCollide = false
block.Transparency = 1

local blockfind = workspace:FindFirstChild(block.Name)
if blockfind and blockfind ~= block then
  blockfind:Destroy()
end

if humanoidRootPart then
  block.CFrame = humanoidRootPart.CFrame
  task.spawn(function()
    while task.wait() do
      if getgenv().AutoFarm_Level or getgenv().AutoFarmSea or getgenv().AutoEliteHunter or getgenv().AutoPiratesSea or getgenv().AutoFarmBossSelected or getgenv().AutoKillAllBoss or getgenv().AutoRengoku or getgenv().TeleportToFruit then
        local plrRP = Player.Character:FindFirstChild("HumanoidRootPart")
        if block and block.Parent == workspace then
          pcall(function()
            if (plrRP.Position - block.Position).Magnitude <= 250 then
              plrRP.CFrame = block.CFrame
            elseif (plrRP.Position - block.Position).Magnitude > 250 then
              block.CFrame = plrRP.CFrame
            end
          end)
        elseif block then
          block.Parent = workspace
        end
      end
    end
  end)
end

local function PlayerTP(Tween_Pos)
  local plrRP = Player.Character:FindFirstChild("HumanoidRootPart")
  if not plrRP then
    return
  end
  local distance = (plrRP.Position - Tween_Pos.p).Magnitude
  if TPIsland and plrRP and distance >= 8000 then
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", TPIsland)
  else
    if block and distance < 200 then
      block.CFrame = Tween_Pos
    elseif block and distance >= 200 and distance <= 600 then
      game:GetService("TweenService"):Create(block,
      TweenInfo.new(distance / 600, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
      {CFrame = Tween_Pos}):Play()
    elseif block and distance > 600 then
      game:GetService("TweenService"):Create(block,
      TweenInfo.new(distance / 200, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
      {CFrame = Tween_Pos}):Play()
    end
  end
end

local function BoatTP(Boat, pos)
  if Boat then
    local Distance = (Boat.PrimaryPart.Position - pos.p).Magnitude
    game:GetService("TweenService"):Create(Boat.PrimaryPart,
    TweenInfo.new(Distance / 300, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
    {CFrame = pos}):Play()
  end
end

local function TweenNPCSpawn(pos)
  if pos then
    local Enemies = workspace:WaitForChild("Enemies", 20)
    repeat task.wait()
      for _,v in pairs(pos) do
        if not getgenv().AutoFarm_Level or Enemies:FindFirstChild(Quest[3]) then
          break
        end
        if block then
          local tween = game:GetService("TweenService"):Create(block,
          TweenInfo.new((block.Position - v.p).Magnitude / 200, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
          {CFrame = v})tween:Play()tween.Completed:Wait()
        end
      end
    until not getgenv().AutoFarm_Level or Enemies:FindFirstChild(Quest[3])
    return
  end
end

task.spawn(function()
  while task.wait() do
    pcall(function()
      for i, v in pairs(Player.Character:GetChildren()) do
        if v.ClassName == "Part" or v.ClassName == "MeshPart" then
          v.CanCollide = not getgenv().AutoFarmSea or getgenv().AutoFarm_Level or getgenv().AutoEliteHunter or getgenv().AutoPiratesSea or getgenv().AutoFarmBossSelected or getgenv().AutoKillAllBoss or getgenv().AutoRengoku or getgenv().TeleportToFruit
        end
      end
    end)
  end
end)

local time = tick()
local function PlayerClick()
  task.spawn(function()
    pcall(function()
      local CF = debug.getupvalues(require(game.Players.LocalPlayer.PlayerScripts.CombatFramework))[2]
      CF.activeController.attacking = false
      CF.activeController.timeToNextAttack = 0
      CF.activeController.increment = 3
      CF.activeController.hitboxMagnitude = 100
      CF.activeController.blocking = false
      CF.activeController.timeToNextBlock = 0
      CF.activeController.focusStart = 0
      CF.activeController.humanoid.AutoRotate = true
    end)
    if (tick() - time) >= getgenv().AutoClickDelay or 0.1 then
      if getgenv().AutoClick then
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(math.huge, math.huge))
      end
      time = tick()
    end
  end)
end

local function VerifyNPC(npc)
  local RS = game:GetService("ReplicatedStorage")
  local Enemies = workspace:WaitForChild("Enemies", 20)
  return RS:FindFirstChild(npc) or Enemies:FindFirstChild(npc)
end

function AutoHaki()
  if getgenv().AutoHaki and not Player.Character:FindFirstChild("HasBuso") then
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
  end
end

local function EquipTool()
  local backpack = Player.Backpack:GetChildren()
  local plrChar = Player.Character
  for _,v in pairs(backpack) do
    if v.ToolTip == getgenv().FarmMethod then
      v.Parent = plrChar
    end
  end
end

local function FruitFind()
  local fruits = workspace:GetChildren()
  local FruitDistance = math.huge
  local Fruit = nil
  
  for __,fruit in pairs(fruits) do
    local args1 = Player and Player.Character and Player.Character.PrimaryPart
    local args2 = fruit and fruit:IsA("Tool") and fruit:FindFirstChild("Handle")
    if args1 and args2 and (args1.Position - args2.Position).Magnitude <= FruitDistance then
      FruitDistance = (args1.Position - args2.Position).Magnitude
      Fruit = fruit
    end
  end
  return Fruit and Fruit:FindFirstChild("Handle")
end

local function GetProxyChest()
  local chests = workspace:GetChildren()
  local ChestDistance = 700
  local Chest = nil
  
  for _,chest in pairs(chests) do
    if Quest[1] and chest then
      if string.find(chest.Name, "Chest") and chest:IsA("Part") and (chest.Position - Quest[1].p).Magnitude <= ChestDistance then
        ChestDistance = (chest.Position - Quest[1].p).Magnitude
        Chest = chest
      end
    end
  end
  return Chest
end

local function Get_LevelQuest()
  local Level = PlayerLevel.Value
  local Enemies = workspace:WaitForChild("Enemies", 20)
  
  if Sea1 then
    -- Auto Farm Level Sea 1
    if Level < 10 then
      if tostring(Player.Team) == "Pirates" then
        Quest = {CFrame.new(1059, 17, 1546), CFrame.new(), "Bandit", "BanditQuest1", 1}
        QuestTween = {CFrame.new(943, 45, 1562), CFrame.new(1115, 45, 1619), CFrame.new(1265, 45, 1606)}
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-2708, 25, 2103), CFrame.new(), "Trainee", "MarineQuest", 1}
        QuestTween = {CFrame.new(-2754, 50, 2063), CFrame.new(-2950, 70, 2240)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 10 and Level < 15 then
      Quest = {CFrame.new(-1598, 37, 153), CFrame.new(), "Monkey", "JungleQuest", 1}
      QuestTween = {CFrame.new(-1524, 50, 37), CFrame.new(-1424, 50, 216), CFrame.new(-1554, 50, 359), CFrame.new(-1772, 50, 78), CFrame.new(-1715, 50, -61), CFrame.new(-1594, 50, -45)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 15 and Level < 30 then
      if VerifyNPC("The Gorilla King") and Level >= 20 then
        Quest = {CFrame.new(-1598, 37, 153), CFrame.new(-1128, 6, -451), "The Gorilla King", "JungleQuest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-1598, 37, 153), CFrame.new(), "Gorilla", "JungleQuest", 2}
        QuestTween = {CFrame.new(-1128, 40, -451), CFrame.new(-1313, 40, -546)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 30 and Level < 40 then
      Quest = {CFrame.new(-1140, 4, 3829), CFrame.new(), "Pirate", "BuggyQuest1", 1}
      QuestTween = {CFrame.new(-1262, 40, 3905), CFrame.new(-1167, 40, 3942)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 40 and Level < 60 then
      if VerifyNPC("Bobby") and Level >= 55 then
        Quest = {CFrame.new(-1140, 4, 3829), CFrame.new(-1128, 6, -451), "Bobby", "BuggyQuest1", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-1140, 4, 3829), CFrame.new(), "Brute", "BuggyQuest1", 2}
        QuestTween = {CFrame.new(-976, 55, 4304), CFrame.new(-1196, 55, 4287), CFrame.new(-1363, 55, 4162)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 60 and Level < 75 then
      Quest = {CFrame.new(897, 6, 4389), CFrame.new(938, 6, 4470), "Desert Bandit", "DesertQuest", 1}
      QuestTween = nil
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 75 and Level < 90 then
      Quest = {CFrame.new(897, 6, 4389), CFrame.new(1546, 14, 4384), "Desert Officer", "DesertQuest", 2}
      QuestTween = nil
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 90 and Level < 100 then
      Quest = {CFrame.new(1385, 87, -1298), CFrame.new(1303, 106, -1441), "Snow Bandit", "SnowQuest", 1}
      QuestTween = nil
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 100 and Level < 120 then
      if VerifyNPC("Yeti") and Level >= 105 then
        Quest = {CFrame.new(1385, 87, -1298), CFrame.new(1185, 106, -1518), "Yeti", "SnowQuest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(1385, 87, -1298), CFrame.new(1185, 106, -1518), "Snowman", "SnowQuest", 2}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 120 and Level < 150 then
      if VerifyNPC("Vice Admiral") and Level >= 130 then
        Quest = {CFrame.new(-5035, 29, 4326), CFrame.new(-4807, 21, 4360), "Vice Admiral", "MarineQuest2", 2}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-5035, 29, 4326), CFrame.new(-4807, 21, 4360), "Chief Petty Officer", "MarineQuest2", 1}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 150 and Level < 175 then
      Quest = {CFrame.new(-4844, 718, -2621), CFrame.new(-4956, 296, -2901), "Sky Bandit", "SkyQuest", 1}
      QuestTween = nil
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 175 and Level < 190 then
      Quest = {CFrame.new(-4844, 718, -2621), CFrame.new(-5268, 392, -2213), "Dark Master", "SkyQuest", 2}
      QuestTween = nil
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 190 and Level < 210 then
      Quest = {CFrame.new(5306, 2, 477), CFrame.new(5288, 2, 470), "Prisoner", "PrisonerQuest", 1}
      QuestTween = nil
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 210 and Level < 250 then
      if VerifyNPC("Swan") and Level >= 240 then
        Quest = {CFrame.new(5191, 4, 692), CFrame.new(5230, 4, 749), "Swan", "ImpelQuest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      elseif VerifyNPC("Chief Warden") and Level >= 230 then
        Quest = {CFrame.new(5191, 4, 692), CFrame.new(5230, 4, 749), "Chief Warden", "ImpelQuest", 2}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      elseif VerifyNPC("Warden") and Level >= 220 then
        Quest = {CFrame.new(5191, 4, 692), CFrame.new(5230, 4, 749), "Warden", "ImpelQuest", 1}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(5306, 2, 477), CFrame.new(5282, 2, 1052), "Dangerous Prisoner", "PrisonerQuest", 2}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 250 and Level < 275 then
      Quest = {CFrame.new(-1581, 7, -2982), CFrame.new(-1897, 7, -2796), "Toga Warrior", "ColosseumQuest", 1}
      QuestTween = nil
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 275 and Level < 300 then
      Quest = {CFrame.new(-1581, 7, -2982), CFrame.new(-1327, 59, -3231), "Gladiator", "ColosseumQuest", 2}
      QuestTween = {CFrame.new(-1268, 30, -2996), CFrame.new(-1472, 30, -3194), CFrame.new(-1387, 30, -3438), CFrame.new(-1198, 30, -3508)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 300 and Level < 325 then
      Quest = {CFrame.new(-5319, 12, 8515), CFrame.new(), "Military Soldier", "MagmaQuest", 1}
      QuestTween = {CFrame.new(-5335, 46, 8638), CFrame.new(-5512, 30, 8366)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 325 and Level < 375 then
      if VerifyNPC("Magma Admiral") and Level >= 350 then
        Quest = {CFrame.new(-5319, 12, 8515), CFrame.new(-5694, 18, 8735), "Magma Admiral", "MagmaQuest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-5319, 12, 8515), CFrame.new(-5791, 97, 8834), "Military Spy", "MagmaQuest", 2}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 375 and Level < 400 then
      Quest = {CFrame.new(61122, 18, 1567), CFrame.new(), "Fishman Warrior", "FishmanQuest", 1} 
      QuestTween = {CFrame.new(60998, 50, 1534), CFrame.new(60880, 50, 1675), CFrame.new(60785, 50, 1552), CFrame.new(60923, 60, 1262)}
      TPIsland, TPIslandDistance = Vector3.new(61163.8515625, 11.6796875, 1819.7841796875), nil
    elseif Level >= 400 and Level < 450 then
      if VerifyNPC("Fishman Lord") and Level >= 425 then
        Quest = {CFrame.new(61122, 18, 1567), CFrame.new(61350, 31, 1095), "Fishman Lord", "FishmanQuest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = Vector3.new(61163.8515625, 11.6796875, 1819.7841796875), nil
      else
        Quest = {CFrame.new(61122, 18, 1567), CFrame.new(), "Fishman Commando", "FishmanQuest", 2}
        QuestTween = {CFrame.new(61866, 55, 1655), CFrame.new(62043, 18, 1510), CFrame.new(61812, 56, 1254)}
        TPIsland, TPIslandDistance = Vector3.new(61163.8515625, 11.6796875, 1819.7841796875), nil
      end
    elseif Level >= 450 and Level < 475 then
      Quest = {CFrame.new(-4720, 846, -1951), CFrame.new(), "God's Guard", "SkyExp1Quest", 1}
      QuestTween = {CFrame.new(-4641, 880, -1902), CFrame.new(-4781, 880, -1817)}
      TPIsland, TPIslandDistance = Vector3.new(-4607.82275390625, 874.3905029296875, -1667.556884765625), nil
    elseif Level >= 475 and Level < 525 then
      if VerifyNPC("Wysper") and Level >= 500 then
        Quest = {CFrame.new(-7861, 5545, -381), CFrame.new(-7927, 5551, -637), "Wysper", "SkyExp1Quest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = Vector3.new(-7894.61767578125, 5547.1416015625, -380.29119873046875), nil
      else
        Quest = {CFrame.new(-7861, 5545, -381), CFrame.new(), "Shanda", "SkyExp1Quest", 2}
        QuestTween = {CFrame.new(-7741, 5580, -395), CFrame.new(-7591, 5580, -466), CFrame.new(-7643, 5580, -608)}
        TPIsland, TPIslandDistance = Vector3.new(-7894.61767578125, 5547.1416015625, -380.29119873046875), nil
      end
    elseif Level >= 525 and Level < 550 then
      Quest = {CFrame.new(-7903, 5636, -1412), CFrame.new(), "Royal Squad", "SkyExp2Quest", 1}
      QuestTween = {CFrame.new(-7727, 5650, -1410), CFrame.new(-7522, 5650, -1499)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 525 and Level < 625 then
      if VerifyNPC("Thunder God") and Level >= 575 then
        Quest = {CFrame.new(-7903, 5636, -1412), CFrame.new(-7751, 5607, -2315), "Thunder God", "SkyExp2Quest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-7903, 5636, -1412), CFrame.new(), "Royal Soldier", "SkyExp2Quest", 2}
        QuestTween = {CFrame.new(-7894, 5640, -1629), CFrame.new(-7678, 5640, -1696), CFrame.new(-7672, 5640, -1903), CFrame.new(-7925, 5640, -1854)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 625 and Level < 650 then
      Quest = {CFrame.new(5258, 39, 4052), CFrame.new(), "Galley Pirate", "FountainQuest", 1}
      QuestTween = {CFrame.new(5391, 70, 4023), CFrame.new(5780, 70, 3969)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 650 then
      if VerifyNPC("CyborgCombat") and Level >= 675 then
        Quest = {CFrame.new(5258, 39, 4052), CFrame.new(6138, 10, 3939), "CyborgCombat", "FountainQuest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(5258, 39, 4052), CFrame.new(), "Galley Captain", "FountainQuest", 2}
        QuestTween = {CFrame.new(5985, 70, 4790), CFrame.new(5472, 70, 4887)}
        TPIsland, TPIslandDistance = nil, nil
      end
    end
  elseif Sea2 then
    -- Auto Farm Level Sea 2
    if Level >= 700 and Level < 725 then
      Quest = {CFrame.new(-427, 73, 1835), CFrame.new(), "Raider", "Area1Quest", 1}
      QuestTween = {CFrame.new(-614, 90, 2240), CFrame.new(-894, 90, 2275), CFrame.new(-872, 90, 2481), CFrame.new(-552, 90, 2528)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 725 and Level < 775 then
      if VerifyNPC("Diamond") and Level >= 750 then
        Quest = {CFrame.new(-427, 73, 1835), CFrame.new(-1569, 199, -31), "Diamond", "Area1Quest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-427, 73, 1835), CFrame.new(), "Mercenary", "Area1Quest", 2}
        QuestTween = {CFrame.new(-867, 110, 1621), CFrame.new(-1047, 110, 1779), CFrame.new(-1025, 110, 1087), CFrame.new(-1204, 110, 1195)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 775 and Level < 800 then
      Quest = {CFrame.new(635, 73, 919), CFrame.new(), "Swan Pirate", "Area2Quest", 1}
      QuestTween = {CFrame.new(778, 110, 1129), CFrame.new(1018, 110, 1128), CFrame.new(1020, 110, 1366), CFrame.new(1016, 110, 1115)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 800 and Level < 875 then
      if VerifyNPC("Jeremy") and Level >= 850 then
        Quest = {CFrame.new(635, 73, 919), CFrame.new(2316, 449, 787), "Jeremy", "Area2Quest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(635, 73, 919), CFrame.new(), "Factory Staff", "Area2Quest", 2}
        QuestTween = {CFrame.new(882, 110, -49), CFrame.new(723, 110, 212), CFrame.new(473, 110, 108), CFrame.new(-115, 110, 39)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 875 and Level < 900 then
      Quest = {CFrame.new(-2441, 73, -3219), CFrame.new(), "Marine Lieutenant", "MarineQuest3", 1}
      QuestTween = {CFrame.new(-2552, 110, -3050), CFrame.new(-2860, 110, -3089), CFrame.new(-3114, 110, -2947), CFrame.new(-2864, 110, -2679)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 900 and Level < 950 then
      if VerifyNPC("Fajita") and Level >= 925 then
        Quest = {CFrame.new(-2441, 73, -3219), CFrame.new(-2086, 73, -4208), "Fajita", "MarineQuest3", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-2441, 73, -3219), CFrame.new(), "Marine Captain", "MarineQuest3", 2}
        QuestTween = {CFrame.new(-1695, 110, -3299), CFrame.new(-1953, 110, -3165), CFrame.new(-2144, 110, -3341)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 950 and Level < 975 then
      Quest = {CFrame.new(-5495, 48, -794), CFrame.new(), "Zombie", "ZombieQuest", 1}
      QuestTween = {CFrame.new(-5715, 90, -917), CFrame.new(-5534, 90, -942), CFrame.new(-5445, 90, -806), CFrame.new(-5485, 90, -663), CFrame.new(-5730, 90, -590), CFrame.new(-5816, 90, -756)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 975 and Level < 1000 then
      Quest = {CFrame.new(-5495, 48, -794), CFrame.new(), "Vampire", "ZombieQuest", 2}
      QuestTween = {CFrame.new(-6027, 50, -1130), CFrame.new(-6248, 50, -1281), CFrame.new(-6120, 50, -1450), CFrame.new(-5951, 50, -1520), CFrame.new(-5803, 50, -1360)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1000 and Level < 1050 then
      Quest = {CFrame.new(607, 401, -5371), CFrame.new(), "Snow Trooper", "SnowMountainQuest", 1}
      QuestTween = {CFrame.new(445, 440, -5175), CFrame.new(523, 440, -5484), CFrame.new(699, 440, -5612)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1050 and Level < 1100 then
      Quest = {CFrame.new(607, 401, -5371), CFrame.new(), "Winter Warrior", "SnowMountainQuest", 2}
      QuestTween = {CFrame.new(1224, 460, -5332), CFrame.new(1404, 460, -5323), CFrame.new(1258, 460, -5220), CFrame.new(1145, 460, -5077), CFrame.new(1022, 460, -5139)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1100 and Level < 1125 then
      Quest = {CFrame.new(-6061, 16, -4904), CFrame.new(), "Lab Subordinate", "IceSideQuest", 1}
      QuestTween = {CFrame.new(-5941, 50, -4322), CFrame.new(-5765, 50, -4304), CFrame.new(-5608, 50, -4445), CFrame.new(-5683, 50, -4629)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1125 and Level < 1175 then
      if VerifyNPC("Smoke Admiral") and Level >= 1150 then
        Quest = {CFrame.new(-6061, 16, -4904), CFrame.new(-5078, 24, -5352), "Smoke Admiral", "IceSideQuest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-6061, 16, -4904), CFrame.new(), "Horned Warrior", "IceSideQuest", 2}
        QuestTween = {CFrame.new(-6306, 50, -5752), CFrame.new(-6161, 50, -5979), CFrame.new(-6518, 50, -5795), CFrame.new(-6535, 50, -5640)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 1175 and Level < 1200 then
      Quest = {CFrame.new(-5430, 16, -5298), CFrame.new(), "Magma Ninja", "FireSideQuest", 1}
      QuestTween = {CFrame.new(-5233, 60, -6227), CFrame.new(-5194, 60, -6031), CFrame.new(-5651, 60, -5854)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1200 and Level < 1250 then
      Quest = {CFrame.new(-5430, 16, -5298), CFrame.new(), "Lava Pirate", "FireSideQuest", 2}
      QuestTween = {CFrame.new(-4955, 60, -4836), CFrame.new(-5119, 60, -4634), CFrame.new(-5389, 60, -4616), CFrame.new(-5342, 60, -4897)}
      TPIsland, TPIslandDistance = nil, nil
    end
  elseif Sea3 then
    -- Auto Farm Level Sea 3
    if Level >= 1500 and Level < 1525 then
      Quest = {CFrame.new(-291, 44, 5580), CFrame.new(), "Pirate Millionaire", "PiratePortQuest", 1}
      QuestTween = {CFrame.new(-44, 70, 5623), CFrame.new(-219, 70, 5546), CFrame.new(-574, 70, 5496)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1525 and Level < 1575 then
      if VerifyNPC("Stone") and Level >= 1550 then
        Quest = {CFrame.new(-291, 44, 5580), CFrame.new(-1049, 40, 6791), "Stone", "PiratePortQuest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-291, 44, 5580), CFrame.new(), "Pistol Billionaire", "PiratePortQuest", 2}
        QuestTween = {CFrame.new(219, 105, 6018), CFrame.new(-24, 105, 6155), CFrame.new(-312, 105, 6028)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 1575 and Level < 1600 then
      Quest = {CFrame.new(5834, 51, -1103), CFrame.new(), "Dragon Crew Warrior", "AmazonQuest", 1}
      QuestTween = {CFrame.new(5992, 90, -1581), CFrame.new(6364, 90, -1512), CFrame.new(6501, 90, -1104), CFrame.new(6612, 90, -938), CFrame.new(6393, 90, -939)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1600 and Level < 1625 then
      Quest = {CFrame.new(5834, 51, -1103), CFrame.new(), "Dragon Crew Archer", "AmazonQuest", 2}
      QuestTween = {CFrame.new(6472, 370, -151), CFrame.new(6547, 370, -51), CFrame.new(6539, 410, 72), CFrame.new(6737, 410, 249), CFrame.new(6768, 410, 390), CFrame.new(6625, 410, 371)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1625 and Level < 1650 then
      Quest = {CFrame.new(5448, 602, 748), CFrame.new(), "Female Islander", "AmazonQuest2", 1}
      QuestTween = {CFrame.new(4836, 740, 928), CFrame.new(4708, 770, 911), CFrame.new(4672, 790, 695), CFrame.new(4657, 800, 498), CFrame.new(4575, 810, 281)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1650 and Level < 1700 then
      if VerifyNPC("Island Empress") and Level >= 1675 then
        Quest = {CFrame.new(5448, 602, 748), CFrame.new(5730, 602, 199), "Island Empress", "AmazonQuest2", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(5448, 602, 748), CFrame.new(), "Giant Islander", "AmazonQuest2", 2}
        QuestTween = {CFrame.new(4784, 660, 155), CFrame.new(4662, 660, -57), CFrame.new(4869, 660, -178), CFrame.new(5056, 660, -267), CFrame.new(5332, 660, -166)}
        TPIsland, TPIslandDistance = nil, nil 
      end
    elseif Level >= 1700 and Level < 1725 then
      Quest = {CFrame.new(2180, 29, -6738), CFrame.new(), "Marine Commodore", "MarineTreeIsland", 1}
      QuestTween = {CFrame.new(3156, 120, -7837), CFrame.new(2904, 120, -7863), CFrame.new(2606, 120, -7745), CFrame.new(2409, 120, -7874), CFrame.new(2269, 120, -7416), CFrame.new(2413, 120, -7232), CFrame.new(2284, 120, -6911)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1725 and Level < 1775 then
      if VerifyNPC("Kilo Admiral") and Level >= 1750 then
        Quest = {CFrame.new(2180, 29, -6738), CFrame.new(2889, 424, -7233), "Kilo Admiral", "MarineTreeIsland", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(2180, 29, -6738), CFrame.new(), "Marine Rear Admiral", "MarineTreeIsland", 2}
        QuestTween = {CFrame.new(3205, 120, -6742), CFrame.new(3345, 120, -6649), CFrame.new(3776, 210, -7254), CFrame.new(3879, 220, -7083), CFrame.new(3887, 210, -6841), CFrame.new(3546, 210, -6809), CFrame.new(3448, 210, -7014), CFrame.new(3504, 210, -7230)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 1775 and Level < 1800 then
      Quest = {CFrame.new(-10581, 332, -8758), CFrame.new(), "Fishman Raider", "DeepForestIsland3", 1}
      QuestTween = {CFrame.new(-10550, 380, -8574), CFrame.new(-10860, 380, -8459), CFrame.new(-10578, 380, -8331), CFrame.new(-10377, 380, -8238), CFrame.new(-10147, 380, -8216), CFrame.new(-10234, 380, -8454)}
      TPIsland, TPIslandDistance = nil, nil 
    elseif Level >= 1800 and Level < 1825 then
      Quest = {CFrame.new(-10581, 332, -8758), CFrame.new(), "Fishman Captain", "DeepForestIsland3", 2}
      QuestTween = {CFrame.new(-10764, 380, -8799), CFrame.new(-10844, 380, -9030), CFrame.new(-11160, 380, -9166), CFrame.new(-11073, 380, -8846), CFrame.new(-11043, 380, -8619)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1825 and Level < 1850 then
      Quest = {CFrame.new(-13233, 332, -7626), CFrame.new(), "Forest Pirate", "DeepForestIsland", 1}
      QuestTween = {CFrame.new(-13335, 380, -7660), CFrame.new(-13138, 380, -7713), CFrame.new(-13298, 380, -7876), CFrame.new(-13512, 380, -7983), CFrame.new(-13632, 380, -7815)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1850 and Level < 1900 then
      if VerifyNPC("Captain Elephant") and Level >= 1875 then
        Quest = {CFrame.new(-13233, 332, -7626), CFrame.new(), "Captain Elephant", "DeepForestIsland", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-13233, 332, -7626), CFrame.new(), "Mythological Pirate", "DeepForestIsland", 2}
        QuestTween = {CFrame.new(-13844, 520, -7016), CFrame.new(-13710, 520, -6856), CFrame.new(-13482, 520, -6985), CFrame.new(-13224, 580, -6806)}
        TPIsland, TPIslandDistance = nil, nil
      end
    elseif Level >= 1900 and Level < 1925 then
      Quest = {CFrame.new(-12682, 391, -9901), CFrame.new(), "Jungle Pirate", "DeepForestIsland2", 1}
      QuestTween = {CFrame.new(-12166, 380, -10375), CFrame.new(-12303, 380, -10639), CFrame.new(-11904, 380, -10469), CFrame.new(-11636, 380, -10511), CFrame.new(-11735, 380, -10687), CFrame.new(-11937, 380, -10713)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1925 and Level < 1975 then
      Quest = {CFrame.new(-12682, 391, -9901), CFrame.new(), "Musketeer Pirate", "DeepForestIsland2", 2}
      QuestTween = {CFrame.new(-13098, 450, -9831), CFrame.new(-13222, 450, -9621), CFrame.new(-13530, 450, -9760), CFrame.new(-13455, 450, -9940)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 1975 and Level < 2000 then
      Quest = {CFrame.new(-9481, 142, 5565), CFrame.new(), "Reborn Skeleton", "HauntedQuest1", 1}
      QuestTween = {CFrame.new(-8680, 190, 5852), CFrame.new(-8879, 190, 5900), CFrame.new(-8865, 190, 6100), CFrame.new(-8774, 170, 6169), CFrame.new(-8649, 190, 6071)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 200 and Level < 2025 then
      Quest = {CFrame.new(-9481, 142, 5565), CFrame.new(), "Living Zombie", "HauntedQuest1", 2}
      QuestTween = {CFrame.new(-10104, 200, 5739), CFrame.new(-10078, 200, 5953), CFrame.new(-10195, 200, 6139), CFrame.new(-10252, 200, 5973)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 2025 and Level < 2050 then
      Quest = {CFrame.new(-9515, 172, 6078), CFrame.new(), "Demonic Soul", "HauntedQuest2", 1}
      QuestTween = {CFrame.new(-9275, 210, 6166), CFrame.new(-9379, 210, 6076), CFrame.new(-9565, 210, 6201), CFrame.new(-9671, 210, 6096)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 2050 and Level < 2075 then
      Quest = {CFrame.new(-9515, 172, 6078), CFrame.new(), "Posessed Mummy", "HauntedQuest2", 2}
      QuestTween = {CFrame.new(-9442, 60, 6304), CFrame.new(-9427, 60, 6148), CFrame.new(-9598, 60, 6121), CFrame.new(-9733, 60, 6119), CFrame.new(-9735, 60, 6336), CFrame.new(-9618, 60, 6323)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 2075 and Level < 2100 then
      Quest = {CFrame.new(-2104, 38, -10194), CFrame.new(), "Peanut Scout", "NutsIslandQuest", 1}
      QuestTween = {CFrame.new(-1870, 100, -10225), CFrame.new(-2143, 100, -10106)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 2100 and Level < 2125 then
      Quest = {CFrame.new(-2104, 38, -10194), CFrame.new(), "Peanut President", "NutsIslandQuest", 2}
      QuestTween = {CFrame.new(-2005, 100, -10585), CFrame.new(-2293, 88, -10512)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 2125 and Level < 2150 then
      Quest = {CFrame.new(-818, 66, -10964), CFrame.new(), "Ice Cream Chef", "IceCreamIslandQuest", 1}
      QuestTween = {CFrame.new(-501, 100, -10883), CFrame.new(-763, 100, -10834), CFrame.new(-990, 100, -11085)}
      TPIsland, TPIslandDistance = nil, nil
    elseif Level >= 2150 and Level < 2200 then
      if VerifyNPC("Cake Queen") and Level >= 2175 then
        Quest = {CFrame.new(-818, 66, -10964), CFrame.new(-710, 382, -11150), "Cake Queen", "IceCreamIslandQuest", 3}
        QuestTween = nil
        TPIsland, TPIslandDistance = nil, nil
      else
        Quest = {CFrame.new(-818, 66, -10964), CFrame.new(), "Ice Cream Commander", "IceCreamIslandQuest", 2}
        QuestTween = {CFrame.new(-690, 100, -11350), CFrame.new(-534, 100, -11284), CFrame.new(-720, 180, -11162)}
        TPIsland, TPIslandDistance = nil, nil
      end
    end
  end
end

local function StartQuest(quest, number)
  local plrRP = Player.Character:FindFirstChild("HumanoidRootPart")
  if plrRP and (plrRP.Position - Quest[1].p).Magnitude <= 5 then
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Quest[4] or nil, Quest[5] or nil)
  else
    PlayerTP(Quest[1])
  end
end

PlayerLevel.Changed:Connect(function()Get_LevelQuest()end)Get_LevelQuest()
task.spawn(function()while task.wait(1) do Get_LevelQuest()end end)

local function BringNPC(enemie)
  local Enemies = workspace:WaitForChild("Enemies", 20)
  for _,v in pairs(Enemies:GetChildren()) do
    if v.Name == enemie.Name then
      local args1 = v and v:FindFirstChild("HumanoidRootPart")
      local args2 = enemie and enemie:FindFirstChild("HumanoidRootPart")
      local args3 = enemie and enemie:FindFirstChild("Humanoid")
      local args4  = v and v:FindFirstChild("Humanoid")
      if args1 and args2 and (args1.Position - args2.Position).Magnitude <= 250 then
				args1.CFrame = args2.CFrame
				args1.CanCollide = false
				args1.Size = Vector3.new(50, 50, 50)
				if args4:FindFirstChild("Animator") then
					args4.Animator:Destroy()
				end
				if args4 and args4.Health <= 0 then
				  v:Destroy()
				end
				sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius",  math.huge)
      end
    end
  end
end

local function AutoFarm_Level()
  while getgenv().AutoFarm_Level do task.wait()
    if getgenv().AutoEliteHunter and VerifyNPC("Urban") or getgenv().AutoEliteHunter and VerifyNPC("Deandre") or getgenv().AutoEliteHunter and VerifyNPC("Diablo") then
    elseif getgenv().TeleportToFruit and FruitFind() then
    else
      local Enemies = workspace:WaitForChild("Enemies")
      local Enemie = Enemies:FindFirstChild(Quest[3])
      local QuestActive = Player.PlayerGui.Main.Quest
      if Enemie and Enemie:FindFirstChild("Humanoid") and Enemie.Humanoid.Health <= 0 then
        Enemie:Destroy()
      end
      if not QuestActive.Visible then
        QuestActive.Container.QuestTitle.Title.Text = ""
      end
      if QuestActive.Visible and not string.find(QuestActive.Container.QuestTitle.Title.Text, Quest[3]) then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
      end
      if not QuestActive.Visible and not string.find(QuestActive.Container.QuestTitle.Title.Text, Quest[3]) then
        StartQuest(Quest[4], Quest[5])
      elseif Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
        PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos)
        pcall(function()AutoHaki()EquipTool()BringNPC(Enemie)PlayerClick()end)
      elseif GetProxyChest() then
        PlayerTP(GetProxyChest().CFrame)
      else
        local args = Player and Player.Character and Player.Character.PrimaryPart
        if QuestTween and QuestTween[1] and args and (args.Position - QuestTween[1].p).Magnitude < 8000 then
          TweenNPCSpawn(QuestTween)
        else
          PlayerTP(Quest[2])
        end
      end
    end
  end
end

local function VerifyEnemie(enemie)
  local Enemies = workspace:WaitForChild("Enemies", 9e9)
  return Enemies and Enemies:FindFirstChild(enemie)
end

local function AutoFarmSea()
  while getgenv().AutoFarmSea do task.wait()
    local plr = game.Players.LocalPlayer
    local plrChar = plr.Character
    local plrBoat = workspace.Boats:FindFirstChild("Guardian")
    
    if plrChar and plrChar.PrimaryPart then
      
      if plrBoat and (plrBoat.PrimaryPart.Position - plrChar.PrimaryPart.Position).Magnitude > 5000 then
        plrBoat:Destroy()
      end
      
      if plrBoat then
        if not plrBoat:FindFirstChild("BodyVelocity") then
          local BV = Instance.new("BodyVelocity", plrBoat)
          BV.Velocity = Vector3.new()
        end
        for _,part in pairs(plrBoat:GetDescendants()) do
          if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
          end
        end
      end
      
      local Enemies = workspace:WaitForChild("Enemies", 20)
      local Terrorshark = Enemies:FindFirstChild("Terrorshark")
      local Shark = Enemies:FindFirstChild("Shark")
      local Piranha = Enemies:FindFirstChild("Piranha")
      local FishCrewMember = Enemies:FindFirstChild("Fish Crew Member")
      local FishBoat = Enemies:FindFirstChild("FishBoat")
      
      if not plrBoat then
        local BuyBoatDistance = (plrChar.PrimaryPart.Position - Vector3.new(-4602, 16, -2880)).Magnitude
        if BuyBoatDistance > 700 then
          game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5073, 315, -3153))
        elseif BuyBoatDistance <= 5 then
          game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "Guardian")
        else
          PlayerTP(CFrame.new(-4602, 16, -2880))
        end
        
      elseif Terrorshark and Terrorshark:FindFirstChild("HumanoidRootPart") then
        PlayerTP(Terrorshark.HumanoidRootPart.CFrame + Vector3.new(0, 20, 20))
        pcall(function()AutoHaki()EquipTool()PlayerClick()plrChar.Humanoid.Sit = false end)
        
        if Terrorshark:FindFirstChild("Humanoid") and Terrorshark.Humanoid.Health <= 0 then
          Terrorshark:Destroy()
        end
        
      elseif Piranha and Piranha:FindFirstChild("HumanoidRootPart") then
        PlayerTP(Piranha.HumanoidRootPart.CFrame + getgenv().FarmPos)
        pcall(function()AutoHaki()EquipTool()PlayerClick()BringNPC(Piranha)plrChar.Humanoid.Sit = false end)
        
      elseif FishCrewMember and FishCrewMember:FindFirstChild("HumanoidRootPart") then
        PlayerTP(FishCrewMember.HumanoidRootPart.CFrame + getgenv().FarmPos)
        pcall(function()AutoHaki()EquipTool()PlayerClick()BringNPC(FishCrewMember)plrChar.Humanoid.Sit = false end)
        
      elseif Shark and Shark:FindFirstChild("HumanoidRootPart") then
        PlayerTP(Shark.HumanoidRootPart.CFrame + getgenv().FarmPos)
        pcall(function()AutoHaki()EquipTool()PlayerClick()plrChar.Humanoid.Sit = false end)
        
        if Shark:FindFirstChild("Humanoid") and Shark.Humanoid.Health <= 0 then
          Shark:Destroy()
        end
        
      elseif FishBoat and FishBoat.PrimaryPart then
        
        PlayerTP(FishBoat.PrimaryPart.CFrame)
        pcall(function()AutoHaki()EquipTool()PlayerClick()plrChar.Humanoid.Sit = false end)
        
      elseif plrBoat and plrBoat:FindFirstChild("VehicleSeat") then
        PlayerTP(plrBoat.VehicleSeat.CFrame)
      end
      if plrChar:FindFirstChild("Humanoid") and plrBoat and plrBoat:FindFirstChild("VehicleSeat") and plrChar.Humanoid.SeatPart ~= plrBoat.VehicleSeat then
        plrChar.Humanoid.Sit = false
        BoatTP(plrBoat, plrBoat.PrimaryPart.CFrame)
      end
      if plrBoat and plrBoat:FindFirstChild("VehicleSeat") and plrChar:FindFirstChild("Humanoid") and plrChar.Humanoid.SeatPart == plrBoat.VehicleSeat then
        BoatTP(plrBoat, CFrame.new(-42756, 21, 446))
      end
    end
  end
end

local function AutoEliteHunter()
  while getgenv().AutoEliteHunter do task.wait()
    if getgenv().TeleportToFruit and FruitFind() then
    else
      local NPC = ""
      local QuestActive = Player.PlayerGui.Main.Quest
      local Remote = game:GetService("ReplicatedStorage").Remotes.CommF_
      
      task.spawn(function()Remote:InvokeServer("EliteHunter")end)
      
      if not QuestActive.Visible then
        QuestActive.Container.QuestTitle.Title.Text = ""
      end
      
      if string.find(QuestActive.Container.QuestTitle.Title.Text, "Diablo") then
        NPC = "Diablo"
      elseif string.find(QuestActive.Container.QuestTitle.Title.Text, "Deandre") then
        NPC = "Deandre"
      else
        NPC = "Urban"
      end
      
      local NPC1 = workspace:WaitForChild("Enemies", 9e9):FindFirstChild(NPC)
      local NPC2 = game:GetService("ReplicatedStorage"):FindFirstChild(NPC)
      
      if NPC1 and NPC1:FindFirstChild("HumanoidRootPart") then
        PlayerTP(NPC1.HumanoidRootPart.CFrame + getgenv().FarmPos)
        pcall(function()AutoHaki()EquipTool()PlayerClick()end)
      elseif NPC2 and NPC2:FindFirstChild("HumanoidRootPart") then
        PlayerTP(NPC2.HumanoidRootPart.CFrame + getgenv().FarmPos)
        pcall(function()AutoHaki()EquipTool()PlayerClick()end)
      end
    end
  end
end

local function AutoPiratesSea()
  while getgenv().AutoPiratesSea do task.wait()
    if Player.Character and Player.Character.PrimaryPart and (Player.Character.PrimaryPart.Position - Vector3.new(-5556, 314, -2988)).Magnitude > 1000 then
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5092, 315, -3130))
    end
    
    local Enemie = nil
    for _,npc in pairs(workspace:WaitForChild("Enemies", 9e9):GetChildren()) do
      if npc and npc.PrimaryPart and (npc.PrimaryPart.Position - Vector3.new(-5556, 314, -2988)).Magnitude < 700 then
        Enemie = npc
      end
    end
    
    if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
      PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos)
      pcall(function()AutoHaki()EquipTool()PlayerClick()end)
    else
      PlayerTP(CFrame.new(-5556, 314, -2988))
    end
    
    task.spawn(function()
      if Enemie and Enemie:FindFirstChild("Humanoid") and Enemie.Humanoid.Health <= 0 then
        Enemie:Destroy()
      end
    end)
  end
end

local function TeleportToFruit()
  while getgenv().TeleportToFruit do task.wait()
    if FruitFind() then
      PlayerTP(FruitFind().CFrame)
    end
  end
end

local function AutoCakePrince()
  while getgenv().AutoCakePrince do task.wait()
    
  end
end

local BossListT = {
  -- Sea 1
  "The Saw",
  "Saber Expert",
  "The Gorilla King",
  "Bobby",
  "Yeti",
  "Vice Admiral",
  "Warden",
  "Chief Warden",
  "Swan",
  "Magma Admiral",
  "Wysper",
  "Thunder God",
  "CyborgCombat",
  "Fishman Lord",
  -- Sea 2
  "Don Swan",
  "Smoke Admiral",
  -- Sea 3
  "Stone",
  "Beautiful Pirate",
  "Island Empress",
  "Kilo Admiral",
  "Captain Elephant",
  "Cake Queen"
}

local function AutoFarmBossSelected()
  local Enemies = workspace:WaitForChild("Enemies", 9e9)
  while getgenv().AutoFarmBossSelected do task.wait()
    local Boss1 = Enemies:FindFirstChild(getgenv().BossSelected or "")
    local Boss2 = game:GetService("ReplicatedStorage"):FindFirstChild(getgenv().BossSelected or "")
    
    if Boss1 then
      PlayerTP(Boss1.HumanoidRootPart.CFrame + getgenv().FarmPos)
      pcall(function()AutoHaki()EquipTool()BringNPC(Boss1)PlayerClick()end)
    elseif Boss2 then
      PlayerTP(Boss2.HumanoidRootPart.CFrame + getgenv().FarmPos)
      pcall(function()AutoHaki()EquipTool()BringNPC(Boss2)PlayerClick()end)
    end
  end
end

local function AutoKillAllBoss()
  local Enemies = workspace:WaitForChild("Enemies", 9e9)
  while getgenv().AutoKillAllBoss do task.wait()
    local Bosses = {}
    for ___,BossName in pairs(BossListT) do
      if VerifyNPC(BossName) then
        table.insert(Bosses, BossName)
      end
    end
    
    local Boss1 = Enemies:FindFirstChild(Bosses[1] or "")
    local Boss2 = game:GetService("ReplicatedStorage"):FindFirstChild(Bosses[1] or "")
    
    if Boss1 then
      PlayerTP(Boss1.HumanoidRootPart.CFrame + getgenv().FarmPos)
      pcall(function()AutoHaki()EquipTool()BringNPC(Boss1)PlayerClick()end)
    elseif Boss2 then
      PlayerTP(Boss2.HumanoidRootPart.CFrame + getgenv().FarmPos)
      pcall(function()AutoHaki()EquipTool()BringNPC(Boss2)PlayerClick()end)
    end
  end
end

local function AutoRengoku()
  while getgenv().AutoRengoku do task.wait()
    
  end
end

local MainFarm = MakeTab({Name = "Auto Farm"})
if Sea3 then
  local AutoSea = MakeTab({Name = "Auto Sea"})
  
  AddSection(AutoSea, {"Farm"})
  
  AddToggle(AutoSea, {
    Name = "Auto Farm Sea",
    Default = false,
    Callback = function(Value)
      getgenv().AutoFarmSea = Value
      AutoFarmSea()
    end
  })
end
local WeaponsTab = MakeTab({Name = "Weapons"})
local FruitAndRaid = MakeTab({Name = "Fruit + Raid"})
local Teleport = MakeTab({Name = "Teleport"})
local Misc = MakeTab({Name = "Misc"})

AddSection(MainFarm, {"Farm"})

AddToggle(MainFarm, {
  Name = "Auto Farm Level",
  Default = false,
  Callback = function(Value)
    getgenv().AutoFarm_Level = Value
    AutoFarm_Level()
  end
})

AddToggle(MainFarm, {
  Name = "Auto Pirates Sea",
  Default = false,
  Callback = function(Value)
    getgenv().AutoPiratesSea = Value
    AutoPiratesSea()
  end
})

AddSection(MainFarm, {"Bosses"})

AddButton(MainFarm, {
  Name = "Update Boss List",
  Callback = function()
    pcall(function()UpdateBossList()end)
  end
})

local BossList = AddDropdown(MainFarm, {
  Name = "Boss List",
  Options = {""},
  Default = "",
  Callback = function(Value)
    getgenv().BossSelected = Value
  end
})

function UpdateBossList()
  local NewOptions = {}
  for ___,NameBoss in pairs(BossListT) do
    if VerifyNPC(NameBoss) then
      table.insert(NewOptions, NameBoss)
    end
  end
  UpdateDropdown(BossList, NewOptions)
end
UpdateBossList()

AddToggle(MainFarm, {
  Name = "Auto Farm Boss Selected",
  Callback = function(Value)
    getgenv().AutoFarmBossSelected = Value
    AutoFarmBossSelected()
  end
})

AddToggle(MainFarm, {
  Name = "Kill All Bosses",
  Callback = function(Value)
    getgenv().AutoKillAllBoss = Value
    AutoKillAllBoss()
  end
})

AddToggle(MainFarm, {
  Name = "Take Quest",
  Default = true,
  Callback = function(Value)
    getgenv().TakeQuestBoss = Value
  end
})

AddSection(MainFarm, {"Configs"})

AddDropdown(MainFarm, {
  Name = "Farm Method",
  Options = {"Melee", "Sword", "Fruit"},
  Default = "Melee",
  Callback = function(Value)
    getgenv().FarmMethod = Value
  end
})

AddSlider(MainFarm, {
  Name = "Farm Distance",
  MinValue = 5,
  MaxValue = 50,
  Default = 20,
  Increase = 1,
  Callback = function(Value)
    getgenv().FarmPos = Vector3.new(0, Value or 15, Value or 10)
  end
})

AddSlider(MainFarm, {
  Name = "Auto Click Delay",
  MinValue = 0,
  MaxValue = 1,
  Default = 0.1,
  Increase = 0.05,
  Callback = function(Value)
    getgenv().AutoClickDelay = Value
  end
})

AddToggle(MainFarm, {
  Name = "Auto Click",
  Default = true,
  Callback = function(Value)
    getgenv().AutoClick = Value
  end
})

AddToggle(MainFarm, {
  Name = "Auto Haki",
  Default = true,
  Callback = function(Value)
    getgenv().AutoHaki = Value
  end
})

AddSection()

AddToggle(FruitAndRaid, {
  Name = "Teleport to Fruit",
  Callback = function(Value)
    getgenv().TeleportToFruit = Value
    TeleportToFruit()
  end
})


Raids_Chip = {
	"Flame", 
	"Ice", 
	"Quake", 
	"Light",
	"Dark",
	"String",
	"Rumble",
	"Magma",
	"Human: Buddha",
	"Sand",
	"Bird: Phoenix"
}


if Sea1 then
  
elseif Sea2 then
  AddSection(WeaponsTab, {"Rengoku"})
  
  AddToggle(WeaponsTab, {
    Name = "Auto Rengoku",
    Default = false,
    Callback = function(Value)
      getgenv().AutoRengoku = Value
      AutoRengoku()
    end
  })

elseif Sea3 then
  AddSection(WeaponsTab, {"Elite Hunter"})
  
  local LabelElite = AddTextLabel(WeaponsTab, {"Elite Stats : not Spawn"})
  local LabelElit3 = AddTextLabel(WeaponsTab, {"Elite Hunter progress : 0"})
  
  task.spawn(function()
    while task.wait() do
      pcall(function()
        if VerifyNPC("Urban") or VerifyNPC("Deandre") or VerifyNPC("Diablo") then
          SetLabel(LabelElite, "Elite Stats : Spawned")
        else
          SetLabel(LabelElite, "Elite Stats : not Spawn")
        end
      end)
    end
  end)
  
  task.spawn(function()
    while task.wait(0.5) do
      SetLabel(LabelElit3, "Elite Hunter progress : " .. game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
    end
  end)
  
  AddToggle(WeaponsTab, {
    Name = "Auto Elite Hunter",
    Default = false,
    Callback = function(Value)
      getgenv().AutoEliteHunter = Value
      AutoEliteHunter()
    end
  })
  
  AddSection(WeaponsTab, {"Cake Prince"})
  
  AddToggle(WeaponsTab, {
    Name = "Auto Cake Prince",
    Default = false,
    Callback = function(Value)
      getgenv().AutoCakePrince = Value
      AutoCakePrince()
    end
  })
end

AddSection(Teleport, {"Teleport to Sea"})

AddButton(Teleport, {
  Name = "Teleport to Sea 1",
  Callback = function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
  end
})

AddButton(Teleport, {
  Name = "Teleport to Sea 2",
  Callback = function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
  end
})

AddButton(Teleport, {
  Name = "Teleport to Sea 3",
  Callback = function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
  end
})

AddSection(Teleport, {"Islands"})

AddDropdown(Teleport, {
  Name = "Select Island",
  Options = IslandsList,
  Default = "",
  Callback = function()
    
  end
})

AddButton(Misc, {
  Name = "Redeem all Codes",
  Callback = function()
    local Codes = {
     "SECRET_ADMIN",
     "EXP_5B",
     "CONTROL",
     "UPDATE11",
     "XMASEXP",
     "1BILLION",
     "ShutDownFix2",
     "UPD14",
     "STRAWHATMAINE",
     "TantaiGaming",
     "Colosseum",
     "Axiore",
     "Sub2Daigrock",
     "Sky Island 3",
     "Sub2OfficialNoobie",
     "SUB2NOOBMASTER123",
     "THEGREATACE",
     "Fountain City",
     "BIGNEWS",
     "FUDD10",
     "SUB2GAMERROBOT_EXP1",
     "UPD15",
     "2BILLION",
     "UPD16",
     "3BVISITS",
     "Starcodeheo",
     "Magicbus",
     "JCWK",
     "Bluxxy",
     "Sub2Fer999",
     "Enyu_is_Pro",
     "KITT_RESET",
     "DRAGONABUSE",
     "Sub2CaptainMaui",
     "DEVSCOOKING",
     "kittgaming",
     "Sub2Fer999",
     "Enyu_is_Pro",
     "Magicbus",
     "JCWK",
     "Starcodeheo",
     "Bluxxy",
     "fudd10_v2",
     "SUB2GAMERROBOT_EXP1",
     "Sub2NoobMaster123",
     "Sub2UncleKizaru",
     "Sub2Daigrock",
     "Axiore",
     "TantaiGaming",
     "StrawHatMaine"
    }
    for _,v in pairs(Codes) do
      game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(v)
    end
  end
})
