--[[
   📦 Rayfield Dropdown Teleport System
   - แสดง item ไม่ซ้ำใน Dropdown
   - กดปุ่ม "Teleport" เพื่อสุ่มวาร์ปไปยัง item ที่เลือก
   - รองรับทั้ง Part และ Model ที่มี PrimaryPart หรือ BasePart

   โดย NARMKUNG x ChatGPT
]]--

-- ✅ Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ✅ Rayfield UI Setup
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Item Teleport",
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   Theme = "Default",
   ToggleUIKeybind = "K"
})

local Tab = Window:CreateTab("วาปไปหาของ", 4483362458)

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
   Name = "🔄 วาร์ปไปยัง ของ",
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

local Tab = Window:CreateTab("วาปไปยังสถานที่", 4483362458)

local Button = Tab:CreateButton({
   Name = "วาร์ปไปกองไฟ",
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
