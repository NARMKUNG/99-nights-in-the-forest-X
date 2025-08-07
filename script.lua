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


local Tab = Window:CreateTab("บินทะลุเเละอืนๆ", 4483362458)
-- ตัวแปรระบบบิน
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local speed = 100
local moveKeys = {
    W = false, A = false, S = false, D = false,
    Space = false, Shift = false
}

-- กดปุ่มเดินทาง
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    local key = input.KeyCode.Name
    if moveKeys[key] ~= nil then
        moveKeys[key] = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    local key = input.KeyCode.Name
    if moveKeys[key] ~= nil then
        moveKeys[key] = false
    end
end)

-- Toggle ปุ่มเปิด/ปิดการบิน
Tab:CreateToggle({
    Name = "บิน",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        flying = Value
    end,
})

-- อัปเดตการบิน
RunService.RenderStepped:Connect(function()
    if not flying then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- สร้าง BodyVelocity
    local bv = hrp:FindFirstChild("BV_Fly") or Instance.new("BodyVelocity")
    bv.Name = "BV_Fly"
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    -- คำนวณทิศ
    local camCF = workspace.CurrentCamera.CFrame
    local dir = Vector3.zero

    if moveKeys.W then dir += camCF.LookVector end
    if moveKeys.S then dir -= camCF.LookVector end
    if moveKeys.A then dir -= camCF.RightVector end
    if moveKeys.D then dir += camCF.RightVector end
    if moveKeys.Space then dir += Vector3.new(0, 1, 0) end
    if moveKeys.Shift then dir -= Vector3.new(0, 1, 0) end

    if dir.Magnitude > 0 then
        bv.Velocity = dir.Unit * speed
    else
        bv.Velocity = Vector3.zero
    end

    -- โทรศัพท์บินตาม
    local phone = workspace:FindFirstChild("Phone")
    if phone and (phone:IsA("Model") or phone:IsA("BasePart")) then
        phone:PivotTo(hrp.CFrame * CFrame.new(2, 0, -2))
    end
end)

-- หยุด BodyVelocity เมื่อปิด Toggle
RunService.Heartbeat:Connect(function()
    if not flying then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local bv = character.HumanoidRootPart:FindFirstChild("BV_Fly")
            if bv then
                bv:Destroy()
            end
        end
    end
end)
