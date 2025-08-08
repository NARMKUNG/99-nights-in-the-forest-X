-- ✅ Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ✅ Rayfield UI Setup
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "NARMKUNG CORE",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "CORE UI",
   LoadingSubtitle = "by NARMKUNG",
   ShowText = "NARMKUNG CORE", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "NARMKUNG คีย์ระบบ",
      Subtitle = "ตัวหลัก ระบบ",
      Note = "โปรดใส่คีย์ในองค์กรลับที่เรารู้กัน : ห้าบบอกใครเด็ดขาด", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"CORE2025"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-------------------------------------------------------------------

local Tab = Window:CreateTab("ข้อมูลการอัพเดท🔄", 4483362458)

local Button = Tab:CreateButton({
   Name = "โปรดอ่าก่อนใช้ ! ถ้า item ใน Menu ไม่โหลดเพื่มออกจากสคริปเเละรันสคริปใหม่ ขอบคุณครับ",
   Callback = function()
   -- The function that takes place when the button is pressed
   end,
})

-------------------------------------------------------------------

local Tab = Window:CreateTab("ผู้เล่น🙍‍♂️", 4483362458)

local Toggle = Tab:CreateToggle({
   Name = "เปิดก่องไม่มี คูดาว์ 📭",
   CurrentValue = false,
   Flag = "ToggleNoCooldown",
   Callback = function(Value)
      for _, prompt in pairs(workspace:GetDescendants()) do
         if prompt:IsA("ProximityPrompt") then
            -- ตรวจสอบก่อนว่า property มีไหมและเขียนได้ไหม
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

local Tab = Window:CreateTab("วาปไปหาของ📦", 4483362458)

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
