-- ORION RED EDITION | BIBLIOTECA LOCAL
-- Botão compacto, arrastável e conectado à janela.
local Library = {}
function Library:CreateWindow(config)
    config = config or {}
    local TS = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    local player = game:GetService("Players").LocalPlayer
    local guiParent = player:WaitForChild("PlayerGui")
    local old = guiParent:FindFirstChild("ORION_RED_EDITION_NOVO")
    if old then old:Destroy() end
    local red = Color3.fromRGB(255, 30, 30)
    local white = Color3.fromRGB(240, 240, 240)
    local dark = Color3.fromRGB(16, 16, 19)
    local muted = Color3.fromRGB(30, 30, 35)
    local gui = Instance.new("ScreenGui")
    gui.Name = "ORION_RED_EDITION_NOVO"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 100
    gui.Parent = guiParent
    local function make(class, parent, props)
        local obj = Instance.new(class)
        for k,v in pairs(props or {}) do obj[k] = v end
        obj.Parent = parent
        return obj
    end
    local function round(obj, radius)
        make("UICorner", obj, {CornerRadius = UDim.new(0,radius)})
    end
    local function stroke(obj, color, thickness)
        return make("UIStroke", obj, {Color=color, Thickness=thickness})
    end
    local function tw(obj, t, props)
        TS:Create(obj, TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play()
    end
    local sound = make("Sound",gui,{SoundId="rbxassetid://145319120",Volume=.45})
    local function click()
        sound.TimePosition = 0
        sound:Play()
    end
    local icon = make("ImageButton",gui,{
        Name="BotaoFlutuante",Size=UDim2.fromOffset(40,40),
        Position=UDim2.new(1,-58,.5,-20),
        BackgroundColor3=dark,Image="rbxassetid://102982964006855",
        ScaleType=Enum.ScaleType.Fit,AutoButtonColor=false,ZIndex=20
    })
    round(icon,10)
    local outline = stroke(icon,red,2)
    outline.Transparency=.2
    local iconScale = make("UIScale",icon,{Scale=1})
    icon.MouseEnter:Connect(function()
        tw(iconScale,.15,{Scale=1.1})
        tw(outline,.15,{Transparency=0,Thickness=3})
    end)
    icon.MouseLeave:Connect(function()
        tw(iconScale,.15,{Scale=1})
        tw(outline,.15,{Transparency=.2,Thickness=2})
    end)
    local panel = make("Frame",gui,{
        Name="Janela",Size=UDim2.fromOffset(350,250),
        Position=UDim2.new(.5,-175,.5,-125),
        BackgroundColor3=dark,Visible=true,Active=true
    })
    round(panel,12)
    stroke(panel,red,2)
    local header = make("TextLabel",panel,{
        Size=UDim2.new(1,-105,0,39),Position=UDim2.fromOffset(12,0),
        BackgroundTransparency=1,Text=(config.HubName or "ORION RED EDITION"),
        TextColor3=white,TextSize=12,Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left
    })
    local close = make("TextButton",panel,{
        Size=UDim2.fromOffset(28,26),Position=UDim2.new(1,-36,0,7),
        BackgroundColor3=Color3.fromRGB(105,20,25),Text="X",
        TextColor3=white,Font=Enum.Font.GothamBold,TextSize=14
    })
    round(close,7)
    local minimize = make("TextButton",panel,{
        Size=UDim2.fromOffset(28,26),Position=UDim2.new(1,-70,0,7),
        BackgroundColor3=muted,Text="–",
        TextColor3=white,Font=Enum.Font.GothamBold,TextSize=15
    })
    round(minimize,7)
    local sidebar = make("ScrollingFrame",panel,{
        Size=UDim2.new(0,103,1,-48),Position=UDim2.fromOffset(9,43),
        BackgroundTransparency=1,ScrollBarThickness=2,
        CanvasSize=UDim2.fromOffset(0,0)
    })
    local sideLayout=make("UIListLayout",sidebar,{Padding=UDim.new(0,5)})
    sideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebar.CanvasSize=UDim2.fromOffset(0,sideLayout.AbsoluteContentSize.Y+8)
    end)
    local content=make("Frame",panel,{
        Size=UDim2.new(1,-125,1,-49),Position=UDim2.fromOffset(116,43),
        BackgroundTransparency=1
    })
    local pages, buttons = {}, {}
    local function setVisible(visible)
        panel.Visible=visible
        if visible then
            panel.Size=UDim2.fromOffset(330,235)
            tw(panel,.2,{Size=UDim2.fromOffset(350,250)})
        end
    end
    -- Arrastar a janela pela barra superior (mouse ou toque)
    local movingPanel = false
    local panelStartInput, panelStartPosition
    header.Active = true
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            movingPanel = true
            panelStartInput = input.Position
            panelStartPosition = panel.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if movingPanel and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - panelStartInput
            panel.Position = UDim2.new(
                panelStartPosition.X.Scale, panelStartPosition.X.Offset + d.X,
                panelStartPosition.Y.Scale, panelStartPosition.Y.Offset + d.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            movingPanel = false
        end
    end)
    local dragging, dragStart, startPos, moved=false,nil,nil,false
    icon.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            moved=false
            dragStart=input.Position
            startPos=icon.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart
            if delta.Magnitude>6 then moved=true end
            icon.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,
                startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch) then
            dragging=false
        end
    end)
    icon.Activated:Connect(function()
        if moved then moved=false return end
        click()
        tw(iconScale,.08,{Scale=.85})
        task.delay(.09,function()
            if icon.Parent then tw(iconScale,.14,{Scale=1}) end
        end)
        setVisible(not panel.Visible)
    end)
    close.Activated:Connect(function() click() setVisible(false) end)
    local minimized=false
    minimize.Activated:Connect(function()
        click()
        minimized=not minimized
        sidebar.Visible=not minimized
        content.Visible=not minimized
        minimize.Text=minimized and "+" or "–"
        tw(panel,.18,{Size=minimized and UDim2.fromOffset(350,39)
            or UDim2.fromOffset(350,250)})
    end)
    local window={Pages=pages,TabButtons=buttons}
    function window:CreateTab(name)
        local page=make("ScrollingFrame",content,{
            Name=name,Size=UDim2.fromScale(1,1),
            BackgroundTransparency=1,Visible=false,
            ScrollBarThickness=3,ScrollBarImageColor3=red,
            CanvasSize=UDim2.fromOffset(0,0)
        })
        local layout=make("UIListLayout",page,{Padding=UDim.new(0,7)})
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+12)
        end)
        local tabButton=make("TextButton",sidebar,{
            Size=UDim2.new(1,-6,0,32),BackgroundColor3=muted,
            Text=name,TextColor3=white,TextSize=11,
            Font=Enum.Font.GothamBold,TextTruncate=Enum.TextTruncate.AtEnd
        })
        round(tabButton,7)
        local function activate()
            click()
            for i,p in ipairs(pages) do
                p.Visible=p==page
                buttons[i].BackgroundColor3=p==page and Color3.fromRGB(83,20,25) or muted
            end
        end
        tabButton.Activated:Connect(activate)
        table.insert(pages,page)
        table.insert(buttons,tabButton)
        if #pages==1 then activate() end
        local tab={}
        function tab:GetPageContainer() return page end
        local function row(label)
            local holder=make("Frame",page,{
                Size=UDim2.new(1,-6,0,38),BackgroundColor3=muted
            })
            round(holder,7)
            make("TextLabel",holder,{
                Size=UDim2.new(1,-115,1,0),Position=UDim2.fromOffset(8,0),
                BackgroundTransparency=1,Text=label,TextColor3=white,
                TextSize=11,Font=Enum.Font.GothamMedium,
                TextXAlignment=Enum.TextXAlignment.Left,
                TextTruncate=Enum.TextTruncate.AtEnd
            })
            return holder
        end
        function tab:AddSwitch(label,default,callback)
            local holder=row(label)
            local state=default==true
            local btn=make("TextButton",holder,{
                Size=UDim2.fromOffset(62,26),Position=UDim2.new(1,-69,.5,-13),
                BackgroundColor3=state and red or Color3.fromRGB(60,60,65),
                Text=state and "ON" or "OFF",TextColor3=white,
                Font=Enum.Font.GothamBold,TextSize=11
            })
            round(btn,7)
            btn.Activated:Connect(function()
                click()
                state=not state
                btn.Text=state and "ON" or "OFF"
                tw(btn,.15,{BackgroundColor3=state and red or Color3.fromRGB(60,60,65)})
                if callback then callback(state) end
            end)
        end
        function tab:AddTextBox(label,placeholder,callback)
            local holder=row(label)
            local box=make("TextBox",holder,{
                Size=UDim2.fromOffset(94,26),Position=UDim2.new(1,-101,.5,-13),
                BackgroundColor3=dark,Text=tostring(placeholder or ""),
                TextColor3=white,TextSize=11,Font=Enum.Font.GothamBold,
                ClearTextOnFocus=false
            })
            round(box,6)
            box.FocusLost:Connect(function()
                if callback then callback(box.Text) end
            end)
        end
        function tab:AddButton(label,buttonText,callback)
            local holder=row(label)
            local btn=make("TextButton",holder,{
                Size=UDim2.fromOffset(94,26),Position=UDim2.new(1,-101,.5,-13),
                BackgroundColor3=Color3.fromRGB(100,22,27),
                Text=buttonText or "Executar",TextColor3=white,
                Font=Enum.Font.GothamBold,TextSize=11
            })
            round(btn,6)
            btn.Activated:Connect(function()
                click()
                if callback then callback() end
            end)
        end
        function tab:AddDropdown(label,options,callback)
            local holder=row(label)
            local selected=1
            local btn=make("TextButton",holder,{
                Size=UDim2.fromOffset(110,26),Position=UDim2.new(1,-117,.5,-13),
                BackgroundColor3=dark,Text=tostring(options[1] or ""),
                TextColor3=white,Font=Enum.Font.GothamBold,TextSize=10,
                TextTruncate=Enum.TextTruncate.AtEnd
            })
            round(btn,6)
            btn.Activated:Connect(function()
                if #options==0 then return end
                click()
                selected=selected%#options+1
                btn.Text=tostring(options[selected])
                if callback then callback(options[selected]) end
            end)
        end
        return tab
    end
    return window
end

-- ===== BIẾN HỆ THỐNG =====
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui") or
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local HttpService = game:GetService("HttpService")

-- ===== KHAI BÁO DỮ LIỆU GAME =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ZAP =
require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("ClientRemotes"))
local MonstersFolder = Workspace:FindFirstChild("Monsters")
local ContainersFolder = Workspace:FindFirstChild("Containers")
local InteractablesFolder = Workspace:FindFirstChild("Interactables")
local SelectedBringType = "Materials"
local startTime = tick()
local fpsStack = {}
local origFogStart = Lighting.FogStart
local origFogEnd = Lighting.FogEnd
local origAtmosphere = Lighting:FindFirstChildWhichIsA("Atmosphere")
local origDensity = origAtmosphere and origAtmosphere.Density or 0

local OriginalSettings = {
   Ambient = Lighting.Ambient,
   OutdoorAmbient = Lighting.OutdoorAmbient,
   GlobalShadows = Lighting.GlobalShadows,
   Brightness = Lighting.Brightness
}

-- ===== BIẾN _G =====
_G.HubName = "ORION RED EDITION"
_G.AuthorName = "ORION"
_G.SpeedActive = false
_G.SpeedBoost = 100
_G.InfJumpActive = false
_G.InstantInteract = false
_G.NoclipActive = false
_G.EspPlayer = false
_G.EspMob = false
_G.EspAllChests = false
_G.ThirdPersonActive = false
_G.CameraDistance = 75
_G.FullBrightActive = false
_G.NoFogActive = false
_G.AutoCollectChest = false
_G.AutoFarm = false
_G.PlatformActive = false
_G.AutoBlueprintMaster = false
_G.BringWeaponsActive = false
_G.AntiKick = false
_G.AutoLoopActive = false
_G.AutoSkip = false
_G.WeaponSlot = 1
_G.AuraDistance = 120
_G.AntiAFK = false
_G.ReduceLag = false
_G.FPSCap = 60
_G.GlobalBringActive = false
_G.AutoPickupActive = false
_G.CurrentLanguage = "PT"
_G.SelectedPickupType = "Materials"
_G.AutoDropActive = false
_G.SelectedDropType = "Materials"

-- ===== WHITELISTS =====
_G.MaterialWhitelist =
{"Nut","WoodStool","BrokenLantern","Painting","Nail","Gear","Lamp","OldCan","Teapot","CrushedCan","VintageTV","Woodchair","Toaster","RockingChair","MetalBarrel","Wheel","CrackedBell","MetalGear","WheelBarrow","MetalBucket","WoodenNail"}

local TargetMobs = {
   ["zombie"] = true, ["tankzombie"] = true, ["peazombie"] = true, ["fastzombie"] = true,
["sewerrat"] = true,
   ["radioactiverat"] = true, ["carrotzombie"] = true, ["applezombie"] = true,
["radioactivecornzombie"] = true,
   ["crawlerzombie"] = true, ["radioactiveapplezombie"] = true, ["radioactivecarrotzombie"] =
true,
   ["radioactivebananazombie"] = true, ["mushroomzombie"] = true, ["enragedfastzombie"] =
true,
   ["evilscientistboss"] = true, ["cherrybombzombie"] = true, ["grapezombie"] = true,
["goldencarrotzombie"] = true,
   ["strawberryzombie"] = true, ["blueberryzombie"] = true, ["doomberryzombie"] = true,
["enragedcactus"] = true,
   ["bananazombie"] = true, ["firezombie"] = true, ["cactus"] = true, ["picklezombie"] = true,
["eggplantzombie"] = true,
   ["cornzombie"] = true, ["onionzombie"] = true, ["ghostpepeer"] = true, ["orangezombie"] =
true, ["tomatozombie"] = true,
   ["potatozombie"] = true,
   ["minigundoomberryzombie"] = true,
   ["peanutzombie"] = true,
   ["tamarindzombie"] = true
}

local WeaponWhitelist = {
   ["DMR"] = true, ["BrassKnucklesdmr"] = true, ["Chainsaw"] = true, ["Revolver"] = true,
["SuperSpeedJuice"] = true,
   ["ExoRifle"] = true, ["JugChugJuice"] = true, ["M4A1"] = true, ["JummyJuice"] = true,
["PowPowJuice"] = true,
   ["JumpyJuice"] = true, ["IronRepairHammer"] = true, ["SpeedJuice"] = true,
   ["gingerbreadman"] = true,
   ["orangejellyzombie"] = true,
   ["pinkjellyzombie"] = true,
   ["greenjellyzombie"] = true
}

local MeatWhitelist = {
   ["Meat"] = true, ["Doomberry"] = true, ["Cheese"] = true, ["RadioactiveApple"] = true,
["RadioactiveEgg"] = true,
   ["RadioactiveBanana"] = true, ["Mushroom"] = true, ["EnragedYeast"] = true, ["GreenPea"]
= true, ["RadioactiveCarrot"] = true,
   ["RadioactiveCorn"] = true, ["Yeast"] = true, ["Apple"] = true, ["Onion"] = true, ["Blueberry"]
= true, ["Potato"] = true,
   ["Grape"] = true, ["Strawberry"] = true, ["ExplosiveMeat"] = true, ["Eggplant"] = true,
["CherryBomb"] = true,
   ["Banana"] = true, ["Pickle"] = true, ["GhostPepper"] = true, ["Chicken"] = true, ["Corn"] =
true, ["PinkPricklyPear"] = true,
   ["RadioactiveRatMeat"] = true, ["Milk"] = true, ["ChocolateMilk"] = true, ["RatMeat"] = true,
["Carrot"] = true,
   ["Orange"] = true, ["CactusMeat"] = true, ["GoldenCarrot"] = true
}

_G.FlySpeed = _G.FlySpeed or 50
local MAX_FLY_SPEED = 750
local bVelocity, bGyro
local renderConnection
local previousSpeedState = false

-- ===== HÀM FLY =====
function StartFly()
   previousSpeedState = _G.SpeedActive
   _G.SpeedActive = false

  if bVelocity then bVelocity:Destroy() end
  if bGyro then bGyro:Destroy() end
  if renderConnection then renderConnection:Disconnect() end

  local character = lp.Character
  if not character or not character:FindFirstChild("HumanoidRootPart") then return end
  local hrp = character.HumanoidRootPart
  local humanoid = character:FindFirstChildOfClass("Humanoid")

  if humanoid then
      humanoid.PlatformStand = true
  end

  bVelocity = Instance.new("BodyVelocity")
  bVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
  bVelocity.Velocity = Vector3.new(0, 0, 0)
  bVelocity.Parent = hrp

  bGyro = Instance.new("BodyGyro")
  bGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
  bGyro.P = 10000
  bGyro.CFrame = Camera.CFrame
  bGyro.Parent = hrp
  renderConnection = RunService.RenderStepped:Connect(function()
    if hrp and bVelocity and bGyro and humanoid then
        bGyro.CFrame = Camera.CFrame
        if humanoid.MoveDirection.Magnitude > 0 then
            local moveDir = humanoid.MoveDirection
            local verticalComponent = Camera.CFrame.LookVector.Y

          local dotProduct = moveDir:Dot(Camera.CFrame.LookVector)
          if dotProduct < 0 then
              verticalComponent = -verticalComponent
          end

          local currentSpeed = _G.FlySpeed or 750
          local safeSpeed = math.min(currentSpeed, MAX_FLY_SPEED)

          bVelocity.Velocity = Vector3.new(moveDir.X, verticalComponent, moveDir.Z).Unit *
safeSpeed
       else
          bVelocity.Velocity = Vector3.new(0, 0, 0)
       end
    end
  end)
end

function StopFly()
  if renderConnection then renderConnection:Disconnect() end
  local character = lp.Character
  if character then
      local humanoid = character:FindFirstChildOfClass("Humanoid")
      if humanoid then humanoid.PlatformStand = false end
  end

  if bVelocity then bVelocity:Destroy() end
  if bGyro then bGyro:Destroy() end
  _G.SpeedActive = previousSpeedState
end

-- ===== HÀM ESP =====
local function CreateESP(obj, color)
   if obj:FindFirstChild("CongESP") then return end
   local hl = Instance.new("Highlight")
   hl.Name = "CongESP"
   hl.FillColor = color
   hl.FillTransparency = 0.5
   hl.OutlineColor = Color3.fromRGB(255, 255, 255)
   hl.OutlineTransparency = 0
   hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
   hl.Parent = obj
end

local function RemoveESP(obj)
   local esp = obj:FindFirstChild("CongESP")
   if esp then esp:Destroy() end
end

local function ApplyChestESP(obj, text, color)
   if obj:FindFirstChild("ChestVisual") then return end
   local billboard = Instance.new("BillboardGui")
   billboard.Name = "ChestVisual"
   billboard.AlwaysOnTop = true
   billboard.Size = UDim2.new(0, 120, 0, 50)
   billboard.StudsOffset = Vector3.new(0, 2, 0)

  local label = Instance.new("TextLabel")
  label.Parent = billboard
  label.Size = UDim2.new(1, 0, 1, 0)
  label.BackgroundTransparency = 1
  label.Text = text
  label.TextColor3 = color
  label.Font = Enum.Font.GothamBold
  label.TextSize = 12
  label.TextStrokeTransparency = 0.3
  billboard.Parent = obj

  task.spawn(function()
     while _G.EspAllChests and obj and obj.Parent do
         local char = lp.Character
         local hrp = char and char:FindFirstChild("HumanoidRootPart")
         if hrp then
             local targetPos = obj:GetPivot().Position
             local d = math.floor((hrp.Position - targetPos).Magnitude)
             label.Text = string.format("%s [%dm]", text, d)
         end
         task.wait(0.5)
     end
     if billboard then billboard:Destroy() end
  end)
end

-- ===== HÀM KIỂM TRA =====
local function IsInWhitelist(objName)
   local cleanedName = objName:lower()
   for _, whiteName in pairs(_G.MaterialWhitelist) do
      if cleanedName == whiteName:lower() then return true end
   end
   return false
end

local function IsTargetMob(objName)
   return TargetMobs[objName:lower():gsub("%s+", "")] or false
end

local function IsWeapon(objName)
   return WeaponWhitelist[objName:gsub("%s+", "")] or false
end

local function IsMeat(objName)
   return MeatWhitelist[objName:gsub("%s+", "")] or false
end

local function BringToPosition(obj, targetCFrame)
   pcall(function()
      local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or
obj:FindFirstChild("Prompt", true)
      if obj:IsA("Model") then
          if obj.PrimaryPart then obj.PrimaryPart.CFrame = targetCFrame + Vector3.new(0, 1,
0) else obj:MoveTo(targetCFrame.Position) end
      else
          obj.Anchored = false
          obj.CanCollide = false
          obj.CFrame = targetCFrame + Vector3.new(0, 1, 0)
      end
      if prompt then task.spawn(function() fireproximityprompt(prompt) end) end
   end)
end

local function UpdateArmVisibility()
   local char = lp.Character
   if not char then return end
   local armTransparency = _G.ThirdPersonActive and 0 or 1
   local cameraObjTransparency = _G.ThirdPersonActive and 1 or 0
   for _, v in pairs(char:GetChildren()) do
       if v:IsA("BasePart") and (v.Name:find("Arm") or v.Name:find("Hand")) then
           v.LocalTransparencyModifier = armTransparency
       end
   end
   for _, v in pairs(Camera:GetChildren()) do
       if v:IsA("Model") or v:IsA("BasePart") then
           if v:IsA("BasePart") then
               v.LocalTransparencyModifier = cameraObjTransparency
           else
               for _, part in pairs(v:GetDescendants()) do
                  if part:IsA("BasePart") then
                      part.LocalTransparencyModifier = cameraObjTransparency
          end
        end
      end
    end
  end
end

local function findItemUUID(obj)
   for attrName, attrValue in pairs(obj:GetAttributes()) do
      if typeof(attrValue) == "string" and string.match(attrValue,
"^%w+-%w+-%w+-%w+-%w+$") then
          return attrValue
      end
   end

  for _, child in pairs(obj:GetChildren()) do
     if child:IsA("StringValue") and string.match(child.Value, "^%w+-%w+-%w+-%w+-%w+$")
then
         return child.Value
     end
  end

  if string.match(obj.Name, "^%w+-%w+-%w+-%w+-%w+$") then
      return obj.Name
  end

  return nil
end

-- ===== HÀM AUTO BANK =====
function ToggleAutoOpenBank(state)
   _G.AutoOpenBankActive = state

  if state then
      task.spawn(function()
         while _G.AutoOpenBankActive do
           if ZAP and ZAP.openBankVault and ZAP.openBankVault.fire then
               pcall(function()
                 ZAP.openBankVault.fire({})
               end)
           end
           task.wait(1.5)
         end
      end)
  end
end

-- ===== TẠO UI BẰNG LIBRARY =====
local Window = Library:CreateWindow({
   HubName = _G.HubName,
   AuthorName = _G.AuthorName
})

-- ===== THÊM PHƯƠNG THỨC AddInfoLabel CHO TAB =====
local originalCreateTab = Window.CreateTab
Window.CreateTab = function(self, name)
   local tab = originalCreateTab(self, name)

  function tab:AddInfoLabel(text, color, sizeY)
    local page = self:GetPageContainer()
    local label = Instance.new("TextLabel", page)
    label.Size = UDim2.new(1, -20, 0, sizeY or 26)
    label.Position = UDim2.new(0, 10, 0, #page:GetChildren() * 32 + 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextWrapped = true
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.RichText = true
    label.LineHeight = 1.2
    return label
  end

  return tab
end

-- ===== ABA INFORMAÇÕES =====
local InfoTab = Window:CreateTab("ℹ️ Informações")
InfoTab:AddInfoLabel("👤 " .. lp.Name .. " (" .. lp.DisplayName .. ")", Color3.fromRGB(255,255,255))
local TimeLabel = InfoTab:AddInfoLabel("⏱️ Tempo de jogo: 00:00:00", Color3.fromRGB(180,255,180))
local FPSLabel = InfoTab:AddInfoLabel("🎮 FPS: --", Color3.fromRGB(255,200,100))
local PingLabel = InfoTab:AddInfoLabel("📶 Ping: -- ms", Color3.fromRGB(100,200,255))
local ServerLabel = InfoTab:AddInfoLabel("🌍 Jogadores no servidor: --", Color3.fromRGB(200,200,255))
local GameTimeLabel = InfoTab:AddInfoLabel("🕒 Horário do jogo: --:--", Color3.fromRGB(255,220,150))
InfoTab:AddInfoLabel("🔴 ORION RED EDITION | Painel independente", Color3.fromRGB(255,70,70), 36)
task.spawn(function()
    local sessionStart = tick()
    while InfoTab and InfoTab:GetPageContainer() and InfoTab:GetPageContainer().Parent do
        local t = math.floor(tick() - sessionStart)
        TimeLabel.Text = string.format("⏱️ Tempo de jogo: %02d:%02d:%02d", t//3600, (t%3600)//60, t%60)
        local fps = 60
        pcall(function() fps = math.floor(1 / RunService.RenderStepped:Wait() + 0.5) end)
        FPSLabel.Text = "🎮 FPS: " .. fps
        pcall(function()
            local pingItem = Stats.Network.ServerStatsItem["Data Ping"]
            if pingItem then PingLabel.Text = "📶 Ping: " .. math.floor(pingItem:GetValue() or 0) .. " ms" end
        end)
        ServerLabel.Text = "🌍 Jogadores no servidor: " .. #Players:GetPlayers()
        local hour = Lighting.ClockTime
        GameTimeLabel.Text = string.format("🕒 Horário do jogo: %02d:%02d", math.floor(hour), math.floor((hour%1)*60))
        task.wait(1)
    end
end)

-- ===== TAB MAIN =====
local MainTab = Window:CreateTab("🎮 Principal")

MainTab:AddSwitch("🏃 Velocidade", _G.SpeedActive, function(s)
  _G.SpeedActive = s
end)

MainTab:AddTextBox("⚡ Intensidade da velocidade", "100", function(v)
  _G.SpeedBoost = tonumber(v) or 100
end)

MainTab:AddSwitch("🕊️ Voar", false, function(s)
  if s then StartFly() else StopFly() end
end)

MainTab:AddTextBox("🚀 Velocidade de voo", "50", function(v)
  _G.FlySpeed = tonumber(v) or 50
end)

MainTab:AddSwitch("🦘 Pulo infinito", _G.InfJumpActive, function(s)
  _G.InfJumpActive = s
end)

MainTab:AddSwitch("⏱️ Interação instantânea", _G.InstantInteract, function(s)
  _G.InstantInteract = s
end)

MainTab:AddSwitch("🚪 Atravessar paredes", _G.NoclipActive, function(s)
  _G.NoclipActive = s
end)

-- ===== TAB PLAYER =====
local PlayerTab = Window:CreateTab("👤 Jogador")

PlayerTab:AddSwitch("📷 Terceira pessoa", _G.ThirdPersonActive, function(s)
  _G.ThirdPersonActive = s
  lp.CameraMode = s and Enum.CameraMode.Classic or
Enum.CameraMode.LockFirstPerson
end)

PlayerTab:AddTextBox("🔭 Distância da câmera", "50", function(v)
  _G.CameraDistance = tonumber(v) or 50
  lp.CameraMaxZoomDistance = _G.CameraDistance
end)

PlayerTab:AddSwitch("💤 Anti-AFK", _G.AntiAFK, function(s)
  _G.AntiAFK = s
end)

PlayerTab:AddSwitch("⚙️ Reduzir lag", _G.ReduceLag, function(s)
  _G.ReduceLag = s
end)

-- ===== TAB ESP =====
local EspTab = Window:CreateTab("👁️ Visão")

EspTab:AddSwitch("👤 Ver jogadores", _G.EspPlayer, function(s)
  _G.EspPlayer = s
end)

EspTab:AddSwitch("👹 Ver monstros", _G.EspMob, function(s)
  _G.EspMob = s
end)

EspTab:AddSwitch("📦 Ver baús", _G.EspAllChests, function(s)
  _G.EspAllChests = s
end)

EspTab:AddSwitch("💡 Visão noturna", _G.FullBrightActive, function(s)
  _G.FullBrightActive = s
end)
EspTab:AddSwitch("🌫️ Remover neblina", _G.NoFogActive, function(s)
  _G.NoFogActive = s
end)

EspTab:AddSwitch("🛡️ Anti-queda", _G.PlatformActive, function(s)
  _G.PlatformActive = s
end)

-- ===== TAB FARM =====
local FarmTab = Window:CreateTab("⚔️ Farm")

FarmTab:AddSwitch("⚔️ Ataque automático", _G.AutoFarm, function(s)
  _G.AutoFarm = s
end)

FarmTab:AddDropdown("🗡️ Espaço da arma", {"1","2","3","4","5","6","7","8","9","10","11","12"},
function(selected)
  _G.WeaponSlot = tonumber(selected) or 1
end)

FarmTab:AddTextBox("📏 Alcance do ataque", tostring(_G.AuraDistance), function(v)
  _G.AuraDistance = tonumber(v) or 120
end)

FarmTab:AddSwitch("📦 Baús automáticos", _G.AutoCollectChest, function(s)
  _G.AutoCollectChest = s
end)

FarmTab:AddSwitch("📜 Projeto automático", _G.AutoBlueprintMaster, function(s)
  _G.AutoBlueprintMaster = s
end)

FarmTab:AddSwitch("☀️ Dias automáticos", _G.AutoLoopActive, function(s)
  _G.AutoLoopActive = s
  _G.AutoSkip = s
end)

FarmTab:AddSwitch("🏦 Banco automático", false, function(s)
  ToggleAutoOpenBank(s)
end)

-- ===== TAB ITEMS =====
local ItemsTab = Window:CreateTab("📦 Itens")

ItemsTab:AddSwitch("🧲 Coleta automática", _G.AutoPickupActive, function(s)
   _G.AutoPickupActive = s
end)
ItemsTab:AddDropdown("📥 Tipo de coleta", {"Materiais", "Corpos de zumbis", "Carnes"},
function(selected)
   _G.SelectedPickupType = ({["Materiais"]="Materials",["Corpos de zumbis"]="Zombie Corpses",["Carnes"]="Meat"})[selected] or "Materials"
end)

ItemsTab:AddSwitch("📦 Trazer itens", _G.GlobalBringActive, function(s)
   _G.GlobalBringActive = s
end)

ItemsTab:AddDropdown("🧰 Tipo de item", {"Materiais", "Corpos de zumbis", "Médicos", "Armas e água", "Carnes"}, function(selected)
   SelectedBringType = ({["Materiais"]="Materials",["Corpos de zumbis"]="Zombie Corpses",["Médicos"]="Medical",["Armas e água"]="Guns & Water",["Carnes"]="Meat"})[selected] or "Materials"
end)

ItemsTab:AddSwitch("📤 Soltar itens (beta)", _G.AutoDropActive, function(s)
   _G.AutoDropActive = s
end)

-- ===== TAB MISC =====
local MiscTab = Window:CreateTab("⚙️ Ajustes")

MiscTab:AddDropdown("🌐 Idioma", {"VN", "EN", "CN", "TH", "JP", "ES", "KR","TR" , "PT"},
function(selected)
  _G.CurrentLanguage = selected
end)

-- FPS Unlocker
MiscTab:AddTextBox("🎮 Limite de FPS", tostring(_G.FPSCap), function(v)
   local num = tonumber(v) or _G.FPSCap
   if num < 1 then num = 1
   elseif num > 120 then num = 120 end
   _G.FPSCap = num
   setfpscap(num)
end)

-- ===== CORE LOGIC =====

-- Speed Hack
RunService.Heartbeat:Connect(function()
   if _G.SpeedActive then
       local Character = lp.Character
       local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
       local Humanoid = Character and Character:FindFirstChild("Humanoid")
       if RootPart and Humanoid and Humanoid.MoveDirection.Magnitude > 0 then
          RootPart.CFrame = RootPart.CFrame + (Humanoid.MoveDirection * _G.SpeedBoost
* 0.016)
       end
   end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.InfJumpActive then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
   if _G.NoclipActive and lp.Character then
       local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
       local rootPart = lp.Character:FindFirstChild("HumanoidRootPart")
       if humanoid and rootPart then
           local shouldCollide = (humanoid:GetState() == Enum.HumanoidStateType.Freefall
and rootPart.Velocity.Y < -40)
           for _, v in pairs(lp.Character:GetChildren()) do
              if v:IsA("BasePart") then v.CanCollide = shouldCollide end
           end
       end
   end
end)

-- Instant Interact
task.spawn(function()
    while task.wait(1) do
      for _, v in pairs(Workspace:GetDescendants()) do
         if v:IsA("ProximityPrompt") then
             if _G.InstantInteract then
                 if v:GetAttribute("OriginalHold") == nil then
                     v:SetAttribute("OriginalHold", v.HoldDuration)
                 end
                 v.HoldDuration = 0
             else
                 if v:GetAttribute("OriginalHold") ~= nil then
                     v.HoldDuration = v:GetAttribute("OriginalHold")
                 end
             end
         end
      end
    end
end)

Workspace.DescendantAdded:Connect(function(v)
  if _G.InstantInteract and v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
end)
-- Anti AFK
Players.LocalPlayer.Idled:Connect(function()
   if _G.AntiAFK then
       VirtualUser:CaptureController()
       VirtualUser:ClickButton2(Vector2.new())
   end
end)

-- Reduce Lag
local function ApplyLag()
   Lighting.GlobalShadows = false
   for _, v in pairs(Workspace:GetDescendants()) do
      if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or
v:IsA("Trail") or v:IsA("Beam") then
          v.Enabled = false
      end
      if v:IsA("BasePart") and v.Material ~= Enum.Material.Plastic then
          v.Material = Enum.Material.Plastic
          v.Reflectance = 0
      end
   end
end

local ReduceLagEnabled = false
task.spawn(function()
   while task.wait(4) do
      if _G.ReduceLag and not ReduceLagEnabled then
          ApplyLag()
          ReduceLagEnabled = true
      elseif not _G.ReduceLag then
          ReduceLagEnabled = false
      end
   end
end)

-- Kill Aura
RunService.Heartbeat:Connect(function()
   if not _G.AutoFarm or not MonstersFolder then return end

  local character = lp.Character
  if not character or not character:FindFirstChild("HumanoidRootPart") then return end

  local root = character.HumanoidRootPart
  local slot = _G.WeaponSlot or 1
  local distance = _G.AuraDistance or 120

  for _, monster in pairs(MonstersFolder:GetChildren()) do
     if monster.Name == "GrimcrustSupreme" then
        local bossPart = monster:FindFirstChild("HumanoidRootPart")
           or monster.PrimaryPart
           or monster:FindFirstChildWhichIsA("BasePart")
        local hum = monster:FindFirstChildOfClass("Humanoid")
        local hasHealth = hum and hum.Health > 0 or monster:GetAttribute("Health") ~= 0

       if bossPart and hasHealth then
           local monsterDistance = (root.Position - bossPart.Position).Magnitude
           if monsterDistance < distance then
              ZAP.meleeAttack.fire({
                 monsters = { monster },
                 civilians = {},
                 activeSlot = slot
              })
           end
       end
       continue
     end

     if monster:FindFirstChild("HumanoidRootPart") then
        local monsterDistance = (root.Position -
monster.HumanoidRootPart.Position).Magnitude
        if monsterDistance < distance then
           local hum = monster:FindFirstChildOfClass("Humanoid")
           if hum and hum.Health > 0 then
               ZAP.meleeAttack.fire({
                  monsters = { monster },
                  civilians = {},
                  activeSlot = slot
               })
           end
        end
     end
  end
end)

-- Auto All Chest
local OpenedChests = {}
task.spawn(function()
   while true do
      task.wait(0.5)
      if _G.AutoCollectChest and ContainersFolder then
          local char = lp.Character
          local hrp = char and char:FindFirstChild("HumanoidRootPart")
          if hrp then
              for _, v in pairs(ContainersFolder:GetChildren()) do
                 if not _G.AutoCollectChest then break end
              local name = v.Name
              local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
              if (name:find("Chest") or name:find("Crate")) and (prompt and prompt.Enabled)
and not OpenedChests[v] then
                  local targetPart = v:IsA("Model") and (v.PrimaryPart or
v:FindFirstChildWhichIsA("BasePart")) or v
                  if targetPart and targetPart:IsA("BasePart") then
                      hrp.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
                      task.wait(0.2)
                      if prompt then
                          prompt.HoldDuration = 0
                          fireproximityprompt(prompt)
                          OpenedChests[v] = true
                          task.wait(0.5)
                      end
                  end
              end
            end
        end
     else
        if next(OpenedChests) ~= nil then OpenedChests = {} end
     end
   end
end)

-- Anti Void
local voidThreshold = Workspace.FallenPartsDestroyHeight
local safeHeight = voidThreshold + 500

local Platform = Instance.new("Part")
Platform.Name = "CongSupreme_Platform"
Platform.Size = Vector3.new(50, 1, 50)
Platform.Anchored = true
Platform.CanCollide = false
Platform.Transparency = 1
Platform.Position = Vector3.new(0, safeHeight - 0.5, 0)
Platform.Parent = Workspace

RunService.Heartbeat:Connect(function()
  if _G.PlatformActive then
      local char = lp.Character
      local hrp = char and char:FindFirstChild("HumanoidRootPart")
      if hrp then
          Platform.CFrame = CFrame.new(hrp.Position.X, safeHeight - 0.5, hrp.Position.Z)
          Platform.CanCollide = true
      else
          Platform.CanCollide = false
      end
  else
     Platform.CanCollide = false
     Platform.CFrame = CFrame.new(0, voidThreshold - 100, 0)
  end
end)

-- Auto Pickup
task.spawn(function()
   while true do
     task.wait(0.2)

       if not _G.AutoPickupActive then continue end
       if not InteractablesFolder then continue end

       for _, obj in pairs(InteractablesFolder:GetChildren()) do
          if not _G.AutoPickupActive then break end

         local name = obj.Name
         local isTarget = false

         if _G.SelectedPickupType == "Materials" and table.find(_G.MaterialWhitelist, name)
then
            isTarget = true
         elseif _G.SelectedPickupType == "Meat" and MeatWhitelist[name] then
            isTarget = true
         elseif _G.SelectedPickupType == "Zombie Corpses" then
            for mobName, _ in pairs(TargetMobs) do
               if string.lower(mobName) == string.lower(name) then
                   isTarget = true
                   break
               end
            end
         end

       if isTarget then
           local uuid = findItemUUID(obj)
           if uuid then
               pcall(function()
                 ZAP.pickupObject.fire(uuid)
                 ZAP.switchSlot.fire(1)
               end)
           end
       end
     end
  end
end)

-- Auto Drop
task.spawn(function()
   while true do
     task.wait(0.01)

     if _G.AutoDropActive then
         local liveDeposit = workspace:FindFirstChild("Stations")
              and workspace.Stations:FindFirstChild("BlueprintsTable")
              and workspace.Stations.BlueprintsTable:FindFirstChild("ObjectDeposit")
         if liveDeposit and liveDeposit:IsDescendantOf(workspace) then
              for slot = 1, 6 do
                 if not _G.AutoDropActive then break end

           pcall(function()
             ZAP.switchSlot.fire(slot)
             task.wait(0.01)
             ZAP.dropObject.fire(liveDeposit)
             task.wait(0.01)
           end)
         end
       end
     end
  end
end)

-- Bring Items
task.spawn(function()
   local FixedCFrame = nil
   local LastBringType = nil

  while true do
    task.wait(0.15)
    if not _G.GlobalBringActive then FixedCFrame = nil continue end
    if LastBringType ~= SelectedBringType then FixedCFrame = nil LastBringType =
SelectedBringType end

     local character = lp.Character
     local rootPart = character and character:FindFirstChild("HumanoidRootPart")

     if rootPart and InteractablesFolder then
         if not FixedCFrame then FixedCFrame = rootPart.CFrame end

       for _, obj in pairs(InteractablesFolder:GetChildren()) do
          if not _G.GlobalBringActive then break end

          if SelectedBringType == "Materials" then
             if not IsInWhitelist(obj.Name) then continue end
             local currentPosition = obj:GetPivot().Position
            if currentPosition and (currentPosition - FixedCFrame.Position).Magnitude > 5
then
               if obj:IsA("Model") then obj:PivotTo(FixedCFrame) else obj.CFrame =
FixedCFrame end
               pcall(function()
                   local mainPart = obj:IsA("Model") and (obj.PrimaryPart or
obj:FindFirstChildOfClass("BasePart")) or obj
                   if mainPart then mainPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
mainPart.AssemblyAngularVelocity = Vector3.new(0,0,0) end
               end)
               task.wait(0.005)
             end

          elseif SelectedBringType == "Zombie Corpses" then
             if not IsTargetMob(obj.Name) then continue end
             local targetPart = obj:IsA("Model") and (obj.PrimaryPart or
obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("BasePart")) or obj
             if targetPart and typeof(targetPart) == "Instance" and targetPart:IsA("BasePart")
and (targetPart.Position - FixedCFrame.Position).Magnitude > 7 then
                 pcall(function()
                     targetPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                     targetPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                     local hum = obj:FindFirstChildOfClass("Humanoid")
                     if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
                 end)
                 if obj:IsA("Model") and obj.PrimaryPart then
obj:SetPrimaryPartCFrame(FixedCFrame) else targetPart.CFrame = FixedCFrame end
                 task.wait(0.05)
             end

          elseif SelectedBringType == "Medical" then
             if not (obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("Model")) then continue
end
              local nameLower = obj.Name:lower()
              if nameLower ~= "bandage" and nameLower ~= "firstaidkit" and nameLower ~=
"revivekit" then continue end

            local currentPosition = obj:GetPivot().Position
            if currentPosition and (currentPosition - FixedCFrame.Position).Magnitude > 5
then
               if obj:IsA("Model") then obj:PivotTo(FixedCFrame) else obj.CFrame =
FixedCFrame end
               pcall(function()
                   local mainPart = obj:IsA("Model") and (obj.PrimaryPart or
obj:FindFirstChildOfClass("BasePart")) or obj
                   if mainPart then mainPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
mainPart.AssemblyAngularVelocity = Vector3.new(0,0,0) end
               end)
              task.wait(0.1)
            end

        elseif SelectedBringType == "Guns & Water" then
           if not ((obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("Model")) and
IsWeapon(obj.Name)) then continue end
           BringToPosition(obj, FixedCFrame)
           task.wait(0.1)

           elseif SelectedBringType == "Meat" then
              if not ((obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("Model")) and
IsMeat(obj.Name)) then continue end
              local currentPosition = obj:GetPivot().Position
              if currentPosition and (currentPosition - FixedCFrame.Position).Magnitude > 5
then
                  if obj:IsA("Model") then obj:PivotTo(FixedCFrame) else obj.CFrame =
FixedCFrame end
                  pcall(function()
                      local mainPart = obj:IsA("Model") and (obj.PrimaryPart or
obj:FindFirstChildOfClass("BasePart")) or obj
                      if mainPart then mainPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
mainPart.AssemblyAngularVelocity = Vector3.new(0,0,0) end
                  end)
                  task.wait(0.005)
              end
           end
        end
     else
        FixedCFrame = nil
     end
   end
end)

-- Auto Days
local POS_SKIP = Vector3.new(-37.91, 51.59, 86.33)
local POS_TREO = Vector3.new(-26.95, 145, 122.67)
local previousFarmStateForSkip = false
local wasAutoSkipActive = false

local function ClickSkip()
   if _G.AutoSkip then
       if not wasAutoSkipActive then
           wasAutoSkipActive = true
           previousFarmStateForSkip = _G.AutoFarm
           _G.AutoFarm = true
       end
   else
       if wasAutoSkipActive then _G.AutoFarm = previousFarmStateForSkip
wasAutoSkipActive = false end
       return false
    end
    for _, v in pairs(Workspace:GetDescendants()) do
       if (v:IsA("ProximityPrompt") or v:IsA("ClickDetector")) then
           local parent = v:FindFirstAncestorWhichIsA("BasePart") or
v:FindFirstAncestorWhichIsA("Attachment")
           if parent then
               local targetPos = parent:IsA("Attachment") and parent.WorldPosition or
parent.Position
               if (targetPos - POS_SKIP).Magnitude < 15 then
                   if v:IsA("ProximityPrompt") then v.HoldDuration = 0 fireproximityprompt(v) else
fireclickdetector(v) end
                   task.wait(0.1)
                   return true
               end
           end
       end
    end
    return false
end

task.spawn(function()
   local skippedForToday = false
   while true do
      task.wait(0.5)
      if _G.AutoLoopActive then
          local char = lp.Character
          local RootPart = char and char:FindFirstChild("HumanoidRootPart")
          local stations = Workspace:FindFirstChild("Stations")
          local openSign = stations and stations:FindFirstChild("OpenSign")
          local switchPart = openSign and openSign:FindFirstChild("Switch")

      if switchPart and switchPart:IsA("BasePart") then switchPart.CFrame =
CFrame.new(POS_TREO) end

      if RootPart then
         local hour = Lighting.ClockTime
         if hour >= 6 and hour < 18 then
             if not skippedForToday then
                 RootPart.CFrame = CFrame.new(POS_SKIP)
                 task.wait(0.4)
                 if ClickSkip() then skippedForToday = true RootPart.CFrame =
CFrame.new(POS_TREO) end
             else
                 if (RootPart.Position - POS_TREO).Magnitude > 5 then RootPart.CFrame =
CFrame.new(POS_TREO) end
              end
           else
              skippedForToday = false
              if (RootPart.Position - POS_TREO).Magnitude > 5 then RootPart.CFrame =
CFrame.new(POS_TREO) end
           end
        end
     else
        skippedForToday = false
        if wasAutoSkipActive then _G.AutoFarm = previousFarmStateForSkip
wasAutoSkipActive = false end
     end
  end
end)

-- Night Vision
task.spawn(function()
   while true do
      if _G.FullBrightActive then
          if Lighting.GlobalShadows ~= false then
              Lighting.Ambient = Color3.fromRGB(200, 200, 200)
              Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
              Lighting.GlobalShadows = false
              Lighting.Brightness = 2
          end
      else
          if Lighting.GlobalShadows == false then
              Lighting.Ambient = OriginalSettings.Ambient
              Lighting.OutdoorAmbient = OriginalSettings.OutdoorAmbient
              Lighting.GlobalShadows = OriginalSettings.GlobalShadows
              Lighting.Brightness = OriginalSettings.Brightness
          end
      end
      task.wait(0.5)
   end
end)

-- No Fog
local fogApplied = false
task.spawn(function()
   while task.wait(1) do
      if _G.NoFogActive then
          if not fogApplied then
              Lighting.FogStart = 999999; Lighting.FogEnd = 999999
              local atmosphere = Lighting:FindFirstChildWhichIsA("Atmosphere")
              if atmosphere then atmosphere.Density = 0 end
              fogApplied = true
          end
     else
        if fogApplied then
            Lighting.FogStart = origFogStart; Lighting.FogEnd = origFogEnd
            local atmosphere = Lighting:FindFirstChildWhichIsA("Atmosphere")
            if atmosphere then atmosphere.Density = origDensity end
            fogApplied = false
        end
     end
  end
end)

-- Auto Blueprint
local BlueprintSequence = {
   {Type = "Farm", Pos = Vector3.new(-432.01, 82.23, -35.68)},
   {Type = "Collect", Pos = Vector3.new(-433.13, 66.98, 9.00)},
   {Type = "Farm", Pos = Vector3.new(-118.78, 67.92, -167.74)},
   {Type = "Collect", Pos = Vector3.new(-142.67, 53.77, -211.52)},
   {Type = "Farm", Pos = Vector3.new(251.28, 68.51, -23.98)},
   {Type = "Collect", Pos = Vector3.new(229.28, 51.85, -33.03)},
   {Type = "Farm", Pos = Vector3.new(627.25, 66.60, -185.59)},
   {Type = "Collect", Pos = Vector3.new(657.27, 68.38, -179.39)},
   {Type = "Collect", Pos = Vector3.new(667.93, 56.22, -134.54)},
   {Type = "Farm", Pos = Vector3.new(658.80, 73.01, 228.37)},
   {Type = "Collect", Pos = Vector3.new(690.56, 66.78, 273.21)},
   {Type = "Collect", Pos = Vector3.new(456.61, 55.92, -597.25)},
   {Type = "Farm", Pos = Vector3.new(989.22, 81.00, -126.43)},
   {Type = "GetCode", Pos = Vector3.new(983.45, 54.10, -93.26)},
   {Type = "Final", Pos = Vector3.new(1037.90, 65.60, -126.34)}
}
local previousFarmState = false
local wasAutoBlueprintActive = false

local function interactWithPrompt()
   local character = lp.Character
   if not character or not character:FindFirstChild("HumanoidRootPart") then return end
   local hrp = character.HumanoidRootPart
   for _, descendant in ipairs(Workspace:GetDescendants()) do
       if descendant:IsA("ProximityPrompt") then
           local part = descendant:FindFirstAncestorWhichIsA("BasePart") or
descendant:FindFirstAncestorWhichIsA("Attachment")
           if part then
               local targetPos = part:IsA("Attachment") and part.WorldPosition or part.Position
               if (hrp.Position - targetPos).Magnitude < 25 then
                   descendant.HoldDuration = 0
                   fireproximityprompt(descendant)
                   task.wait(0.1)
               end
           end
    end
  end
end

local function countMonstersNearby(centerPos)
   local count = 0
   if MonstersFolder then
      for _, monster in ipairs(MonstersFolder:GetChildren()) do
         local mHrp = monster:FindFirstChild("HumanoidRootPart") or
monster:FindFirstChildWhichIsA("BasePart")
         if mHrp then if (centerPos - mHrp.Position).Magnitude <= 100 then count = count + 1
end end
      end
   end
   return count
end

task.spawn(function()
   local index = 1
   while true do
      if _G.AutoBlueprintMaster then
          if not wasAutoBlueprintActive then
              wasAutoBlueprintActive = true
              previousFarmState = _G.AutoFarm
              _G.AutoFarm = true; index = 1
          end
          local character = lp.Character
          local hrp = character and character:FindFirstChild("HumanoidRootPart")
          if hrp then
              local currentStep = BlueprintSequence[index]
              if not currentStep then _G.AutoBlueprintMaster = false continue end
              local targetPos = (type(currentStep.Pos) == "table") and currentStep.Pos[1] or
currentStep.Pos
              if currentStep.Type == "Farm" then
                  hrp.CFrame = CFrame.new(targetPos)
                  task.wait(1.5)
                  while _G.AutoBlueprintMaster and currentStep.Type == "Farm" do
                     if countMonstersNearby(targetPos) == 0 then index = index + 1 break end
                     task.wait(1)
                  end
              else
                  hrp.CFrame = CFrame.new(targetPos)
                  task.wait(1)
                  interactWithPrompt()
                  task.wait(0.5)
                  index = index + 1
              end
          end
     else
        if wasAutoBlueprintActive then _G.AutoFarm = previousFarmState
wasAutoBlueprintActive = false end
     end
     task.wait(0.1)
  end
end)

-- Third Person
local isThirdPersonRunning = false
RunService.RenderStepped:Connect(function()
   if _G.ThirdPersonActive then
       isThirdPersonRunning = true
       lp.CameraMode = Enum.CameraMode.Classic
       lp.CameraMaxZoomDistance = _G.CameraDistance or 50
   else
       if isThirdPersonRunning then
           isThirdPersonRunning = false
           lp.CameraMaxZoomDistance = 0.5
           lp.CameraMode = Enum.CameraMode.LockFirstPerson
       end
   end
   UpdateArmVisibility()
end)

-- Chest ESP
task.spawn(function()
   while true do
     if _G.EspAllChests and ContainersFolder then
         for _, v in pairs(ContainersFolder:GetChildren()) do
            if v.Name:find("Chest") or v.Name:find("Crate") or v.Name:find("Mystery") then
                ApplyChestESP(v, v.Name, Color3.fromRGB(255, 165, 0))
            end
         end
     else
         if ContainersFolder then
            for _, v in pairs(ContainersFolder:GetChildren()) do
                local visual = v:FindFirstChild("ChestVisual")
                if visual then visual:Destroy() end
            end
         end
     end
     task.wait(20)
   end
end)

-- Player ESP
local ActiveEspTags = {}
local function CreateHighlight(target, color, isPlayer)
   if target:FindFirstChild("EspHighlight") then return end
   local hl = Instance.new("Highlight")
   hl.Name = "EspHighlight"
   hl.FillColor = color
   hl.OutlineColor = Color3.fromRGB(255, 255, 255)
   hl.FillTransparency = 0.5
   hl.OutlineTransparency = 0
   hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
   hl.Parent = target

   local billboard = Instance.new("BillboardGui")
   billboard.Name = "EspTag"
   billboard.Size = UDim2.new(0, 200, 0, 50)
   billboard.AlwaysOnTop = true
   billboard.StudsOffset = Vector3.new(0, 3, 0)
   local attachPart = target:FindFirstChild("HumanoidRootPart") or
target:FindFirstChildWhichIsA("BasePart")
   if attachPart then
       billboard.Parent = attachPart
   end

  local label = Instance.new("TextLabel", billboard)
  label.Size = UDim2.new(1, 0, 1, 0)
  label.BackgroundTransparency = 1
  label.Text = target.Name
  label.TextColor3 = color
  label.Font = Enum.Font.GothamBold
  label.TextSize = 14
  label.TextStrokeTransparency = 0

  ActiveEspTags[target] = {hl, billboard}
end

local function RemoveEspTag(target)
   if not target then return end
   if ActiveEspTags[target] then
       for _, obj in pairs(ActiveEspTags[target]) do
          if obj then obj:Destroy() end
       end
       ActiveEspTags[target] = nil
   end
end

task.spawn(function()
   while true do
     task.wait(1)
     for _, player in pairs(Players:GetPlayers()) do
        if player ~= lp and _G.EspPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                CreateHighlight(char, Color3.fromRGB(0, 255, 0), true)
            else
                RemoveEspTag(char)
            end
        else
            if player.Character then RemoveEspTag(player.Character) end
        end
     end
  end
end)

-- Mob ESP
local ActiveMobTags = {}

task.spawn(function()
   while true do
     task.wait(0.3)

    if _G.EspMob and MonstersFolder then
        for _, obj in pairs(MonstersFolder:GetChildren()) do
           local hrp = obj:FindFirstChild("HumanoidRootPart")
           local hum = obj:FindFirstChildOfClass("Humanoid")

         if obj:IsA("Model") and hrp and hum and hum.Health > 0 then
             if not ActiveMobTags[obj] and not hrp:FindFirstChild("MobNameTag") then
                 local billboard = Instance.new("BillboardGui")
                 billboard.Name = "MobNameTag"
                 billboard.Size = UDim2.new(0, 200, 0, 50)
                 billboard.AlwaysOnTop = true
                 billboard.StudsOffset = Vector3.new(0, 3, 0)
                 billboard.Parent = hrp

             local textLabel = Instance.new("TextLabel", billboard)
             textLabel.Size = UDim2.new(1, 0, 1, 0)
             textLabel.BackgroundTransparency = 1
             textLabel.Text = obj.Name
             textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
             textLabel.Font = Enum.Font.GothamBold
             textLabel.TextSize = 12
             textLabel.TextStrokeTransparency = 0
             textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
             ActiveMobTags[obj] = billboard
           end
         end
        end
        for mob, tag in pairs(ActiveMobTags) do
           local hum = mob:FindFirstChildOfClass("Humanoid")
           if not mob.Parent or not hum or (hum and hum.Health <= 0) then
               if tag then pcall(function() tag:Destroy() end) end
               ActiveMobTags[mob] = nil
           end
        end
     else
        for mob, tag in pairs(ActiveMobTags) do
           if tag then pcall(function() tag:Destroy() end) end
           ActiveMobTags[mob] = nil
        end
        if MonstersFolder then
           for _, obj in pairs(MonstersFolder:GetChildren()) do
               local hrp = obj:FindFirstChild("HumanoidRootPart")
               if hrp and hrp:FindFirstChild("MobNameTag") then
                   pcall(function() hrp.MobNameTag:Destroy() end)
               end
           end
        end
     end
  end
end)

