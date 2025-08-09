-- ===================================
-- NARMKUNG CORE with Kill Aura
-- For: 99 Nights In The Forest
-- ===================================

-- ✅ Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ✅ Rayfield UI Setup
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "NARMKUNG CORE",
   Icon = 0,
   LoadingTitle = "CORE UI",
   LoadingSubtitle = "by NARMKUNG",
   ShowText = "NARMKUNG CORE",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "NARMKUNG คีย์ระบบ",
      Subtitle = "ตัวหลัก ระบบ",
      Note = "โปรดใส่คีย์ในองค์กรลับที่เรารู้กัน : ห้าบบอกใครเด็ดขาด",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"CORE"}
   }
})

-- ===== VARIABLES =====
local KillAuraActive = false

-- ===== CONFIGURATION =====
local CONFIG = {
    DISTANCE = 50,
    DAMAGE = 999,
    DELAY = 0.1
}

-------------------------------------------------------------------

local Tab = Window:CreateTab("ข้อมูลการอัพเดท🔄", 4483362458)

Tab:CreateParagraph({
    Title = "📋 ข้อมูลการอัพเดท",
    Content = "1. ระบบ โจมตีอัตโนมัติ"
})

-------------------------------------------------------------------

local Tab = Window:CreateTab("ผู้เล่น🙍‍♂️", 4483362458)

Tab:CreateParagraph({
    Title = "📋 คำแนะนำการใช้งาน",
    Content = "1. หมวดหมู่ผู้เล่นมีมากมาย\n2. ถ้ามีบัคโปรดเเจ้ง"
})

local Toggle = Tab:CreateToggle({
   Name = "เปิดก่องไม่มี คูดาว์ 📭",
   CurrentValue = false,
   Flag = "ToggleNoCooldown",
   Callback = function(Value)
      for _, prompt in pairs(workspace:GetDescendants()) do
         if prompt:IsA("ProximityPrompt") then
            if Value then
               if pcall(function() prompt.CooldownDuration = 0 end) then end
               if pcall(function() prompt.HoldDuration = 0 end) then end
            else
               if pcall(function() prompt.CooldownDuration = 1 end) then end
               if pcall(function() prompt.HoldDuration = 0.5 end) then end
            end
         end
      end
   end,
})

-------------------------------------------------------------------

local Tab = Window:CreateTab("โจมตี ⚔️", 4483362458)

-- ===== KILL AURA FUNCTION =====
local function StartKillAura()
    spawn(function()
        while KillAuraActive do
            local character = player.Character
            
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                
                -- Find weapon in inventory
                local weapon = player.Inventory:FindFirstChild("Old Axe") or 
                              player.Inventory:FindFirstChild("Good Axe") or
                              player.Inventory:FindFirstChild("Strong Axe") or
                              player.Inventory:FindFirstChild("Chainsaw")
                
                if weapon then
                    local enemiesHit = 0
                    -- Look for enemies in Characters folder
                    for _, enemy in pairs(Workspace.Characters:GetChildren()) do
                        if enemy:IsA("Model") and enemy.PrimaryPart and enemy ~= character then
                            -- Skip friendly NPCs
                            if not enemy.Name:find("Lost Child") and enemy.Name ~= "Pelt Trader" then
                                -- Calculate distance
                                local distance = (enemy.PrimaryPart.Position - rootPart.Position).Magnitude
                                
                                -- Attack if within range
                                if distance <= CONFIG.DISTANCE then
                                    pcall(function()
                                        ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(
                                            enemy, 
                                            weapon, 
                                            CONFIG.DAMAGE, 
                                            rootPart.CFrame
                                        )
                                    end)
                                    enemiesHit = enemiesHit + 1
                                end
                            end
                        end
                    end
                else
                    -- Auto-disable if no weapon
                    if KillAuraActive then
                        Rayfield:Notify({
                            Title = "⚠️ ไม่มีอาวุธ",
                            Content = "กรุณาถืออาวุธ (ขวาน หรือ เลื่อยยนต์)!",
                            Duration = 3,
                            Image = "alert-triangle"
                        })
                        KillAuraActive = false
                    end
                end
            end
            
            wait(CONFIG.DELAY)
        end
    end)
end

Tab:CreateParagraph({
    Title = "📋 คำแนะนำการใช้งาน",
    Content = "1. ถืออาวุธ (ขวาน หรือ เลื่อยยนต์)\n2. เปิดระบบโจมตีอัตโนมัติ\n3. ปรับระยะโจมตีตามต้องการ\n4. ระบบจะโจมตีศัตรูใกล้เคียงอัตโนมัติ"
})

Tab:CreateToggle({
    Name = "🗡️ โจมตีอัตโนมัติ",
    CurrentValue = false,
    Flag = "KillAuraToggle",
    Callback = function(Value)
        KillAuraActive = Value
        
        if Value then
            -- Check for weapon before starting
            local weapon = player.Inventory:FindFirstChild("Old Axe") or 
                          player.Inventory:FindFirstChild("Good Axe") or
                          player.Inventory:FindFirstChild("Strong Axe") or
                          player.Inventory:FindFirstChild("Chainsaw")
            
            if weapon then
                Rayfield:Notify({
                    Title = "⚔️ เปิดระบบโจมตีแล้ว",
                    Content = "ระยะ: " .. CONFIG.DISTANCE .. " | อาวุธ: " .. weapon.Name,
                    Duration = 2,
                    Image = "zap"
                })
                StartKillAura()
            else
                Rayfield:Notify({
                    Title = "❌ ไม่พบอาวุธ",
                    Content = "กรุณาถืออาวุธก่อนเปิดระบบ!",
                    Duration = 3,
                    Image = "alert-circle"
                })
                KillAuraActive = false
                return
            end
        else
            Rayfield:Notify({
                Title = "🛑 ปิดระบบโจมตี",
                Content = "ระบบโจมตีอัตโนมัติถูกปิดแล้ว",
                Duration = 2,
                Image = "shield-off"
            })
        end
    end
})

Tab:CreateSlider({
    Name = "📏 ระยะโจมตี",
    Range = {10, 500},
    Increment = 5,
    Suffix = " หน่วย",
    CurrentValue = CONFIG.DISTANCE,
    Flag = "DistanceSlider",
    Callback = function(Value)
        CONFIG.DISTANCE = Value
        
        if KillAuraActive then
            Rayfield:Notify({
                Title = "📏 เปลี่ยนระยะแล้ว",
                Content = "ระยะใหม่: " .. Value .. " หน่วย",
                Duration = 1,
                Image = "move"
            })
        end
    end
})

Tab:CreateSlider({
    Name = "⚡ ความเร็วโจมตี",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = " วินาที",
    CurrentValue = CONFIG.DELAY,
    Flag = "SpeedSlider",
    Callback = function(Value)
        CONFIG.DELAY = Value
    end
})

Tab:CreateButton({
    Name = "🎯 ทดสอบอาวุธปัจจุบัน",
    Callback = function()
        local weapon = player.Inventory:FindFirstChild("Old Axe") or 
                      player.Inventory:FindFirstChild("Good Axe") or
                      player.Inventory:FindFirstChild("Strong Axe") or
                      player.Inventory:FindFirstChild("Chainsaw")
        
        if weapon then
            Rayfield:Notify({
                Title = "✅ พบอาวุธแล้ว",
                Content = "อาวุธปัจจุบัน: " .. weapon.Name,
                Duration = 2,
                Image = "check-circle"
            })
        else
            Rayfield:Notify({
                Title = "❌ ไม่มีอาวุธ",
                Content = "ไม่พบอาวุธในกระเป๋า",
                Duration = 3,
                Image = "x-circle"
            })
        end
    end
})

-------------------------------------------------------------------

local Tab = Window:CreateTab("วาปไปหาของ📦", 4483362458)

Tab:CreateParagraph({
    Title = "📋 คำแนะนำการใช้งาน",
    Content = "1. โปรดเลือกของก่อนวาป"
})

-- ✅ ตัวแปรเก็บชื่อ item ที่เลือก
local SelectedItemName = nil

-- ✅ ฟังก์ชันดึงชื่อ item (ไม่ซ้ำ)
local function GetUniqueItemNames()
   local itemsFolder = workspace:FindFirstChild("Items")
   local nameSet, uniqueNames = {}, {}

   if itemsFolder then
      for _, item in ipairs(itemsFolder:GetChildren()) do
         if not nameSet[item.Name] then
            nameSet[item.Name] = true
            table.insert(uniqueNames, item.Name)
         end
      end
   end

   return uniqueNames
end

-- ✅ ฟังก์ชันหาตำแหน่งวาร์ป
local function GetTeleportCFrame(object)
   if object:IsA("BasePart") then
      return object.CFrame
   elseif object:IsA("Model") then
      local primary = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
      if primary then
         return primary.CFrame
      end
   end
   return nil
end

-- ✅ Dropdown UI
local Dropdown = Tab:CreateDropdown({
   Name = "เลือกชื่อ ของ",
   Options = GetUniqueItemNames(),
   CurrentOption = {},
   MultipleOptions = false,
   Flag = "SelectedItem",
   Callback = function(selected)
      SelectedItemName = selected[1]
   end
})

-- ✅ ปุ่มวาร์ป
local Button = Tab:CreateButton({
   Name = "🧭 วาร์ปไปหา ของ 📦",
   Callback = function()
      if not SelectedItemName then
         warn("⚠ กรุณาเลือก ของ ก่อนวาร์ป")
         return
      end

      local itemsFolder = workspace:FindFirstChild("Items")
      if not itemsFolder then
         warn("❌ ไม่พบโฟลเดอร์ 'Items' ใน workspace")
         return
      end

      -- ค้นหา item ที่ตรงชื่อทั้งหมด
      local matchingItems = {}
      for _, item in ipairs(itemsFolder:GetChildren()) do
         if item.Name == SelectedItemName then
            table.insert(matchingItems, item)
         end
      end

      if #matchingItems == 0 then
         warn("❌ ไม่มี item ที่ตรงกับชื่อที่เลือก: " .. SelectedItemName)
         return
      end

      -- สุ่มเลือก 1 ชิ้น
      local chosenItem = matchingItems[math.random(1, #matchingItems)]
      local teleportCFrame = GetTeleportCFrame(chosenItem)

      if not teleportCFrame then
         warn("❌ ไม่สามารถหาตำแหน่งวาร์ปของ item นี้ได้")
         return
      end

      -- วาร์ปตัวละคร
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:FindFirstChild("HumanoidRootPart")
      if hrp then
         hrp.CFrame = teleportCFrame + Vector3.new(0, 5, 0)
      else
         warn("⚠ ไม่พบ HumanoidRootPart")
      end
   end
})

-------------------------------------------------------------------

local Tab = Window:CreateTab("วาปไปหาเด็ก👶🏻", 4483362458)

Tab:CreateParagraph({
    Title = "📋 คำแนะนำการใช้งาน",
    Content = "1. โปรดเลือกเด็กก่อนวาป "
})

--📦 สร้างตารางชื่อทั้งหมดใน workspace.Characters ที่ขึ้นต้นด้วย "Lost Child"
local function GetUniqueLostChildren()
    local children = workspace:WaitForChild("Characters"):GetChildren()
    local names = {}
    local unique = {}

    for _, obj in pairs(children) do
        if obj:IsA("Model") and string.match(obj.Name, "^Lost Child") then
            if not unique[obj.Name] then
                table.insert(names, obj.Name)
                unique[obj.Name] = true
            end
        end
    end

    return names
end

--📋 เก็บชื่อ object ปัจจุบันที่เลือกไว้
local selectedName = nil

--🔽 Dropdown UI
local Dropdown = Tab:CreateDropdown({
    Name = "เลือกชื่อ เด็ก 👶🏻",
    Options = GetUniqueLostChildren(),
    CurrentOption = nil,
    MultipleOptions = false,
    Flag = "LostChildDropdown",
    Callback = function(Options)
        selectedName = Options[1] -- เก็บชื่อที่เลือกไว้
    end,
})

--🧭 ปุ่มวาร์ป
Tab:CreateButton({
    Name = "🧭 วาปไปหา เด็ก 👶🏻",
    Callback = function()
        if selectedName then
            local target = workspace:FindFirstChild("Characters"):FindFirstChild(selectedName)
            local player = game.Players.LocalPlayer
            if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target:GetModelCFrame()
            else
                warn("ไม่พบเป้าหมายหรือ Player")
            end
        else
            warn("ยังไม่ได้เลือกชื่อ Lost Child")
        end
    end,
})

-------------------------------------------------------------------

local Tab = Window:CreateTab("วาปไปหาสถานที่🗺️", 4483362458)

Tab:CreateParagraph({
    Title = "📋 คำแนะนำการใช้งาน",
    Content = "1. ถ้ากดวาปเเล้วไม่ไปเเสดงว่า สถานที่นั้นยังไม่เกิด "
})

local Button = Tab:CreateButton({
   Name = "วาร์ปไปหา กองไฟ 🔥",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")

      local target = workspace:WaitForChild("Map")
         :WaitForChild("Campground")
         :WaitForChild("MainFire")

      if target and target:IsA("Model") and target.PrimaryPart then
         hrp.CFrame = target.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
      else
         warn("MainFire ไม่มี PrimaryPart")
      end
   end,
})

local Button = Tab:CreateButton({
   Name = "วาร์ปไปหา ฐานเพรช 💎",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")

      local target = workspace:WaitForChild("Items")
         :WaitForChild("Stronghold Diamond Chest")

      if target and target:IsA("Model") and target.PrimaryPart then
         hrp.CFrame = target.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
      else
         warn("Sign ไม่มี PrimaryPart")
      end
   end,
})

local Button = Tab:CreateButton({
   Name = "วาร์ปไปหา ฐานเอเลี่ยน 👽",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")

      local target = workspace:WaitForChild("Items")
         :WaitForChild("Alien Chest")

      if target and target:IsA("Model") and target.PrimaryPart then
         hrp.CFrame = target.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
      else
         warn("Alien Chest ไม่มี PrimaryPart")
      end
   end,
})

-------------------------------------------------------------------
-- ===== STATUS MONITORING =====
spawn(function()
    while true do
        wait(5) -- Check every 5 seconds
        
        if KillAuraActive then
            -- Check if player still has weapon
            local weapon = player.Inventory:FindFirstChild("Old Axe") or 
                          player.Inventory:FindFirstChild("Good Axe") or
                          player.Inventory:FindFirstChild("Strong Axe") or
                          player.Inventory:FindFirstChild("Chainsaw")
            
            if not weapon then
                KillAuraActive = false
                Rayfield:Notify({
                    Title = "⚠️ สูญเสียอาวุธ",
                    Content = "ระบบโจมตีถูกปิดเนื่องจากไม่พบอาวุธ",
                    Duration = 3,
                    Image = "alert-triangle"
                })
            end
        end
    end
end)

-- ===== SUCCESS MESSAGE =====
Rayfield:Notify({
    Title = "🎉 NARMKUNG CORE พร้อมใช้งาน",
    Content = "ใช้งานให้สนุกนะครับมีบัคโปรดเเจ้ง",
    Duration = 4,
    Image = "check"
})

print("✅ NARMKUNG CORE loaded!")
print("🎮 Press 'K' to toggle UI")
